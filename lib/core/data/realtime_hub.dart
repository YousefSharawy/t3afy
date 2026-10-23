import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Columns written by the 60 s presence heartbeat. An UPDATE that changes only
/// these must never trigger a data refetch (it used to reload Home,
/// Performance, Profile and the Manager volunteers list every minute).
const presenceColumns = {'is_online', 'last_seen_at', 'updated_at'};

/// True when [next] differs from [prev] only in presence columns.
bool isPresenceOnlyChange(Map<String, dynamic>? prev, Map<String, dynamic> next) {
  if (prev == null || prev.isEmpty) return false;
  var compared = 0;
  for (final e in next.entries) {
    if (presenceColumns.contains(e.key)) continue;
    if (!prev.containsKey(e.key)) return false;
    compared++;
    if (prev[e.key] != e.value) return false;
  }
  return compared > 0;
}

/// Presence-only check for one payload. Uses the old record when the table has
/// REPLICA IDENTITY FULL, otherwise the last record this listener saw.
bool isPresenceOnlyUpdate(
  PostgresChangePayload p, [
  Map<String, dynamic>? lastSeen,
]) {
  if (p.eventType != PostgresChangeEvent.update) return false;
  final oldR = p.oldRecord.length > 1 ? p.oldRecord : lastSeen;
  return isPresenceOnlyChange(oldR, p.newRecord);
}

/// The id of the row a payload is about (new record, or old for DELETE).
String? payloadRowId(PostgresChangePayload p) =>
    (p.newRecord['id'] ?? p.oldRecord['id'])?.toString();

/// For unfiltered DELETE watches (filters don't apply to deletes): true when
/// the deleted row provably belongs to someone else. The old record carries
/// [column] only with REPLICA IDENTITY FULL; without it we can't tell, so the
/// delete is kept (one cheap refetch).
bool deletedRowNotFor(PostgresChangePayload p, String column, String value) {
  final v = p.oldRecord[column];
  return v != null && '$v' != value;
}

class _Watch {
  _Watch(this.table, this.onChange);
  final String table;
  final void Function()? onChange;

  /// False once the server rejected the postgres_changes subscription (table
  /// not in the `supabase_realtime` publication, RLS, timeout...).
  bool healthy = true;
}

/// Owns a set of realtime channels for one cubit/datasource.
///
/// * Coalesces bursts of events into one call per distinct callback
///   ([debounce], default 250 ms), but never delays longer than [maxWait]
///   while events keep arriving (GPS pings, check-in waves).
/// * Drops presence-only updates on `users` (unless the watch opts in via
///   `keepPresence` to patch them from the payload).
/// * `onPayload` lets a cubit patch its state straight from the event; return
///   true when that fully handled it and no refetch is needed.
/// * App resume: supabase_flutter disconnects the socket while the app is in
///   the background, so events are missed. Every live hub re-runs its
///   callbacks once on [AppLifecycleState.resumed] (see [resumeAll]).
/// * Degraded mode: when the server refuses a subscription, that watch's
///   callback is polled every [fallbackPoll] while the app is in the
///   foreground, so screens still converge until realtime is fixed.
/// * [dispose] calls `removeChannel` (plain `unsubscribe` leaked the channel).
class RealtimeHub {
  RealtimeHub({
    SupabaseClient? client,
    this.debounce = const Duration(milliseconds: 250),
    Duration? maxWait,
    this.fallbackPoll = const Duration(seconds: 30),
    this.refreshOnResume = true,
  }) : maxWait =
           maxWait ??
           (debounce * 4 < const Duration(seconds: 1)
               ? const Duration(seconds: 1)
               : debounce * 4),
       _client = client ?? Supabase.instance.client {
    _live.add(this);
    _ensureLifecycle();
  }

  final SupabaseClient _client;
  final Duration debounce;
  final Duration maxWait;
  final Duration fallbackPoll;

  /// Re-run the callbacks once when the app returns from the background.
  final bool refreshOnResume;

  final List<RealtimeChannel> _channels = [];
  final List<_Watch> _watches = [];
  final Set<void Function()> _pending = {};
  final Map<String, Map<String, dynamic>> _lastUsers = {};
  Timer? _timer;
  DateTime? _firstPendingAt;
  Timer? _pollTimer;
  bool _disposed = false;

  // ---- app lifecycle (one listener for all hubs) ----

  static final Set<RealtimeHub> _live = {};
  static AppLifecycleListener? _lifecycle;
  static bool _foreground = true;
  static DateTime? _backgroundSince;

  static void _ensureLifecycle() {
    if (_lifecycle != null) return;
    try {
      _lifecycle = AppLifecycleListener(
        onStateChange: (s) {
          if (s == AppLifecycleState.resumed) {
            final since = _backgroundSince;
            _foreground = true;
            _backgroundSince = null;
            // Ignore brief inactive blips (system sheets, permission prompts).
            if (since != null &&
                DateTime.now().difference(since) >= const Duration(seconds: 2)) {
              resumeAll();
            }
            for (final h in _live) {
              h._syncPoll();
            }
          } else if (s == AppLifecycleState.paused ||
              s == AppLifecycleState.hidden) {
            _foreground = false;
            _backgroundSince ??= DateTime.now();
            for (final h in _live) {
              h._syncPoll();
            }
          }
        },
      );
    } catch (_) {
      // Binding not ready yet; the next hub will try again.
    }
  }

  /// One silent refresh for every live hub (events may have been missed while
  /// the realtime socket was disconnected in the background).
  static void resumeAll() {
    for (final h in List<RealtimeHub>.of(_live)) {
      if (h.refreshOnResume) h.refreshNow();
    }
  }

  /// Runs every watch's callback once (debounced/deduplicated).
  void refreshNow() {
    for (final w in _watches) {
      final cb = w.onChange;
      if (cb != null) _schedule(cb);
    }
  }

  // ---- watches ----

  /// Seed the last-known `users` row (call after a fetch) so the very first
  /// heartbeat after load is recognised as presence-only.
  void rememberUser(Map<String, dynamic> row) {
    final id = row['id'];
    if (id != null) _lastUsers['$id'] = Map.of(row);
  }

  /// Listen to [table] changes.
  ///
  /// * [filter] narrows server-side, e.g.
  ///   `PostgresChangeFilter(type: eq, column: 'user_id', value: id)`.
  ///   Postgres-changes filters are not applied to DELETE events; watch
  ///   deletes separately (unfiltered) when they matter.
  /// * [ignore] lets the caller drop echoes of its own writes.
  /// * [onPayload] runs immediately; return true when it patched the state
  ///   and [onChange] (the debounced refetch) is not needed.
  /// * [keepPresence] passes presence-only `users` updates to [onPayload]
  ///   (they still never trigger [onChange]).
  void watch({
    required String name,
    required String table,
    void Function()? onChange,
    PostgresChangeEvent event = PostgresChangeEvent.all,
    PostgresChangeFilter? filter,
    bool Function(PostgresChangePayload p)? ignore,
    bool Function(PostgresChangePayload p)? onPayload,
    bool keepPresence = false,
  }) {
    if (_disposed) return;
    final w = _Watch(table, onChange);
    _watches.add(w);
    final channel = _client.channel(
      '$name-${DateTime.now().microsecondsSinceEpoch}',
    );
    channel
        .onPostgresChanges(
          event: event,
          schema: 'public',
          table: table,
          filter: filter,
          callback: (p) {
            if (_disposed) return;
            if (table == 'users') {
              final id = '${p.newRecord['id']}';
              final presenceOnly = isPresenceOnlyUpdate(p, _lastUsers[id]);
              if (p.newRecord.isNotEmpty) _lastUsers[id] = p.newRecord;
              if (presenceOnly) {
                if (keepPresence && onPayload != null) onPayload(p);
                return;
              }
            }
            if (ignore != null && ignore(p)) return;
            if (onPayload != null && onPayload(p)) return;
            if (onChange != null) _schedule(onChange);
          },
        )
        // A refused postgres_changes join still answers the channel join with
        // "ok"; the real verdict arrives as a `system` event.
        .onSystemEvents((payload) {
          if (payload is! Map || payload['extension'] != 'postgres_changes') {
            return;
          }
          _setHealthy(w, payload['status'] == 'ok', payload['message']);
        })
        .subscribe((status, error) {
          if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut) {
            _setHealthy(w, false, error ?? status.name);
          }
        });
    _channels.add(channel);
  }

  void _setHealthy(_Watch w, bool healthy, Object? why) {
    if (_disposed || w.healthy == healthy) return;
    w.healthy = healthy;
    if (!healthy && kDebugMode) {
      debugPrint('RealtimeHub: `${w.table}` not delivering ($why); polling');
    }
    // Back online after a failure: catch up on anything missed meanwhile.
    if (healthy && w.onChange != null) _schedule(w.onChange!);
    _syncPoll();
  }

  void _syncPoll() {
    final broken = _watches.any((w) => !w.healthy && w.onChange != null);
    if (_disposed || !broken || !_foreground) {
      _pollTimer?.cancel();
      _pollTimer = null;
      return;
    }
    _pollTimer ??= Timer.periodic(fallbackPoll, (_) {
      for (final w in _watches) {
        if (!w.healthy && w.onChange != null) _schedule(w.onChange!);
      }
    });
  }

  void _schedule(void Function() cb) {
    if (_disposed) return;
    _pending.add(cb);
    final now = DateTime.now();
    final first = _firstPendingAt ??= now;
    final left = maxWait - now.difference(first);
    final wait = left < debounce
        ? (left.isNegative ? Duration.zero : left)
        : debounce;
    _timer?.cancel();
    _timer = Timer(wait, _flush);
  }

  void _flush() {
    _timer = null;
    _firstPendingAt = null;
    final cbs = List<void Function()>.of(_pending);
    _pending.clear();
    if (_disposed) return;
    for (final cb in cbs) {
      cb();
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _live.remove(this);
    _timer?.cancel();
    _pollTimer?.cancel();
    _pending.clear();
    final list = List<RealtimeChannel>.of(_channels);
    _channels.clear();
    for (final c in list) {
      await _client.removeChannel(c);
    }
  }
}
