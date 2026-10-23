import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/safe_emit.dart';

class OnlineStatusState {}

class OnlineStatusCubit extends Cubit<OnlineStatusState>
    with SafeEmit<OnlineStatusState>, WidgetsBindingObserver {
  final SupabaseClient _client;
  Timer? _heartbeat;
  bool _observerAdded = false;

  OnlineStatusCubit(this._client) : super(OnlineStatusState()) {
    _initOnline();
  }

  static bool _tracksPresence(String? role) => role != null && role != 'admin';

  void _addObserver() {
    if (_observerAdded) return;
    WidgetsBinding.instance.addObserver(this);
    _observerAdded = true;
  }

  void _removeObserver() {
    if (!_observerAdded) return;
    WidgetsBinding.instance.removeObserver(this);
    _observerAdded = false;
  }

  Future<void> _initOnline() async {
    if (!_tracksPresence(LocalAppStorage.getUserRole())) return;
    if (LocalAppStorage.getUserId() == null) return;
    _addObserver();
    await _setOnline(true);
    _startHeartbeat();
  }

  Future<void> reinitOnline() async {
    if (isClosed || !_tracksPresence(LocalAppStorage.getUserRole())) return;
    _addObserver();
    await _setOnline(true);
    _startHeartbeat();
  }

  /// Logout: mark the user offline and stop all presence work. Must run
  /// before the session is cleared (it needs the stored user id/role).
  Future<void> goOffline() async {
    _heartbeat?.cancel();
    _heartbeat = null;
    _removeObserver();
    await _setOnline(false);
  }

  void _startHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isClosed || !_tracksPresence(LocalAppStorage.getUserRole())) {
        timer.cancel();
        return;
      }
      _setOnline(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (isClosed) return;
    if (state == AppLifecycleState.resumed) {
      _setOnline(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _setOnline(false);
    }
  }

  Future<void> _setOnline(bool isOnline) async {
    if (!_tracksPresence(LocalAppStorage.getUserRole())) return;
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;
    try {
      await _client
          .from('users')
          .update({
            'is_online': isOnline,
            'last_seen_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', userId);
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _heartbeat?.cancel();
    _setOnline(false);
    _removeObserver();
    return super.close();
  }
}
