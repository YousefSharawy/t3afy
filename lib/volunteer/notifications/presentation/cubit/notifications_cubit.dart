import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/clear_all_notifications_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_all_as_read_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_as_read_use_case.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState>
    with SafeEmit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;
  final ClearAllNotificationsUseCase _clearAllNotificationsUseCase;

  RealtimeHub? _hub;
  String? _currentVolunteerId;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._markAsReadUseCase,
    this._markAllAsReadUseCase,
    this._clearAllNotificationsUseCase,
  ) : super(NotificationsStateInitial());

  void _subscribeToRealtime(String volunteerId) {
    _hub?.dispose();
    _hub = RealtimeHub()
      ..watch(
        name: 'volunteer_notes_$volunteerId',
        table: 'admin_notes',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'volunteer_id',
          value: volunteerId,
        ),
        // UPDATEs are our own read-receipts echoing back (state is already
        // updated optimistically); new notes are prepended from the payload.
        event: PostgresChangeEvent.insert,
        onPayload: _prependFromPayload,
        onChange: _silentReload,
      )
      // Removed notes. Deletes can't be filtered server-side; the old row
      // carries volunteer_id only with REPLICA IDENTITY FULL.
      ..watch(
        name: 'volunteer_notes_del_$volunteerId',
        table: 'admin_notes',
        event: PostgresChangeEvent.delete,
        ignore: (p) => deletedRowNotFor(p, 'volunteer_id', volunteerId),
        onPayload: _removeFromPayload,
        onChange: _silentReload,
      );
  }

  void _silentReload() {
    final id = _currentVolunteerId;
    if (id != null && !isClosed) loadNotifications(id);
  }

  /// Announcement / alert from the manager: shown at once, no refetch.
  bool _prependFromPayload(PostgresChangePayload p) {
    final current = state;
    if (current is! NotificationsStateLoaded) return false;
    final AdminNote note;
    try {
      note = AdminNote.fromJson(p.newRecord);
    } catch (_) {
      return false;
    }
    if (current.notes.any((n) => n.id == note.id)) return true;
    safeEmit(NotificationsStateLoaded([note, ...current.notes]));
    return true;
  }

  bool _removeFromPayload(PostgresChangePayload p) {
    final current = state;
    final id = p.oldRecord['id']?.toString();
    if (current is! NotificationsStateLoaded || id == null) return false;
    // Unknown row (someone else's note without REPLICA IDENTITY FULL): nothing
    // to do here.
    if (!current.notes.any((n) => n.id == id)) return true;
    safeEmit(
      NotificationsStateLoaded(current.notes.where((n) => n.id != id).toList()),
    );
    return true;
  }

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }

  /// First load emits loading; later loads replace the list in place and a
  /// failure keeps the current list. Returns the error message, if any.
  Future<String?> loadNotifications(String volunteerId) async {
    if (_currentVolunteerId != volunteerId) {
      _currentVolunteerId = volunteerId;
      _subscribeToRealtime(volunteerId);
    }
    final hadData = state is NotificationsStateLoaded;
    if (!hadData) safeEmit(NotificationsStateLoading());
    final result = await _getNotificationsUseCase(volunteerId);
    return result.fold(
      (failure) {
        if (!hadData) safeEmit(NotificationsStateError(failure.message));
        return failure.message;
      },
      (notes) {
        safeEmit(NotificationsStateLoaded(notes));
        return null;
      },
    );
  }

  AdminNote _asRead(AdminNote note) => AdminNote(
    id: note.id,
    volunteerId: note.volunteerId,
    title: note.title,
    message: note.message,
    isRead: true,
    createdAt: note.createdAt,
  );

  /// Optimistic: the note is marked read immediately and restored on failure.
  /// Returns the error message, if any.
  Future<String?> markAsRead(String noteId) async {
    final current = state;
    if (current is! NotificationsStateLoaded) return null;
    final before = current.notes;
    safeEmit(
      NotificationsStateLoaded(
        before.map((n) => n.id == noteId ? _asRead(n) : n).toList(),
      ),
    );
    final result = await _markAsReadUseCase(noteId);
    return result.fold((failure) {
      _restore(before);
      return failure.message;
    }, (_) => null);
  }

  Future<String?> markAllAsRead(String volunteerId) async {
    final current = state;
    if (current is! NotificationsStateLoaded) return null;
    final before = current.notes;
    safeEmit(NotificationsStateLoaded(before.map(_asRead).toList()));
    final result = await _markAllAsReadUseCase(volunteerId);
    return result.fold((failure) {
      _restore(before);
      return failure.message;
    }, (_) => null);
  }

  /// Keeps the list on screen until the delete succeeds.
  Future<String?> clearAllNotifications(String volunteerId) async {
    final result = await _clearAllNotificationsUseCase(volunteerId);
    return result.fold((failure) => failure.message, (_) {
      safeEmit(NotificationsStateLoaded(const []));
      return null;
    });
  }

  /// Puts back the read flags captured before an optimistic update, without
  /// dropping notes a realtime refresh may have added meanwhile.
  void _restore(List<AdminNote> before) {
    final current = state;
    if (current is! NotificationsStateLoaded) return;
    final wasRead = {for (final n in before) n.id: n.isRead};
    safeEmit(
      NotificationsStateLoaded(
        current.notes.map((n) {
          final old = wasRead[n.id];
          if (old == null || old == n.isRead) return n;
          return AdminNote(
            id: n.id,
            volunteerId: n.volunteerId,
            title: n.title,
            message: n.message,
            isRead: old,
            createdAt: n.createdAt,
          );
        }).toList(),
      ),
    );
  }
}
