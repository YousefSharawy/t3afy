import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';
import 'package:t3afy/admin/notifications/domain/use_cases/get_admin_notifications_use_case.dart';
import 'package:t3afy/admin/notifications/domain/use_cases/mark_admin_notification_read_use_case.dart';
import 'package:t3afy/admin/notifications/domain/use_cases/mark_all_admin_notifications_read_use_case.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'admin_notifications_state.dart';

class AdminNotificationsCubit extends Cubit<AdminNotificationsState>
    with SafeEmit<AdminNotificationsState> {
  final GetAdminNotificationsUseCase _getUseCase;
  final MarkAdminNotificationReadUseCase _markReadUseCase;
  final MarkAllAdminNotificationsReadUseCase _markAllReadUseCase;

  RealtimeHub? _hub;
  String? _currentAdminId;

  AdminNotificationsCubit(
    this._getUseCase,
    this._markReadUseCase,
    this._markAllReadUseCase,
  ) : super(AdminNotificationsInitial());

  List<AdminNotification>? get _current {
    final s = state;
    return s is AdminNotificationsLoaded ? s.notifications : null;
  }

  /// The manager's own inbox is `admin_id = me AND volunteer_id = me`.
  /// Filtering on `volunteer_id` server-side keeps out the N inserts of every
  /// announcement this manager sends to volunteers (and their read receipts).
  void _subscribeToRealtime(String adminId) {
    _hub?.dispose();
    _hub = RealtimeHub()
      ..watch(
        name: 'admin-notes-$adminId',
        table: 'admin_notes',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'volunteer_id',
          value: adminId,
        ),
        ignore: (p) => _isOwnEcho(p, adminId),
        onChange: () {
          final id = _currentAdminId;
          if (id != null) _fetch(id);
        },
      );
  }

  bool _isOwnEcho(PostgresChangePayload p, String adminId) {
    final row = p.newRecord;
    final rowAdmin = row['admin_id'];
    if (rowAdmin != null && rowAdmin != adminId) return true;
    // Our own markAsRead / markAllAsRead: already applied optimistically.
    if (p.eventType == PostgresChangeEvent.update && row['is_read'] == true) {
      final local = _current?.where((n) => n.id == row['id']);
      if (local != null && local.isNotEmpty && local.first.isRead) return true;
    }
    return false;
  }

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }

  Future<void> loadNotifications(String adminId) async {
    if (_currentAdminId != adminId) {
      _currentAdminId = adminId;
      _subscribeToRealtime(adminId);
    }
    if (_current == null) emit(AdminNotificationsLoading());
    await _fetch(adminId);
  }

  /// Pull-to-refresh: keeps the list; returns an error message on failure.
  Future<String?> refresh(String adminId) => _fetch(adminId);

  Future<String?> _fetch(String adminId) async {
    final result = await _getUseCase(adminId);
    return result.fold(
      (failure) {
        if (_current == null) {
          safeEmit(AdminNotificationsError(failure.message));
        }
        return failure.message;
      },
      (notes) {
        safeEmit(AdminNotificationsLoaded(notes));
        return null;
      },
    );
  }

  /// Optimistic; rolls back and returns an error message on failure.
  Future<String?> markAsRead(String noteId) async {
    final before = _current;
    if (before == null) return null;
    emit(
      AdminNotificationsLoaded(
        before
            .map((n) => n.id == noteId ? n.copyWith(isRead: true) : n)
            .toList(),
      ),
    );
    final result = await _markReadUseCase(noteId);
    return result.fold((failure) {
      _rollback(before);
      return failure.message;
    }, (_) => null);
  }

  /// Optimistic; rolls back and returns an error message on failure.
  Future<String?> markAllAsRead(String adminId) async {
    final before = _current;
    if (before == null) return null;
    emit(
      AdminNotificationsLoaded(
        before.map((n) => n.copyWith(isRead: true)).toList(),
      ),
    );
    final result = await _markAllReadUseCase(adminId);
    return result.fold((failure) {
      _rollback(before);
      return failure.message;
    }, (_) => null);
  }

  void _rollback(List<AdminNotification> before) {
    safeEmit(AdminNotificationsLoaded(before));
  }
}
