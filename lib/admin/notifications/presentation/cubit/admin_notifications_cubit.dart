import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';
import 'package:t3afy/admin/notifications/domain/use_cases/get_admin_notifications_use_case.dart';
import 'package:t3afy/admin/notifications/domain/use_cases/mark_admin_notification_read_use_case.dart';
import 'package:t3afy/admin/notifications/domain/use_cases/mark_all_admin_notifications_read_use_case.dart';

part 'admin_notifications_state.dart';

class AdminNotificationsCubit extends Cubit<AdminNotificationsState> {
  final GetAdminNotificationsUseCase _getUseCase;
  final MarkAdminNotificationReadUseCase _markReadUseCase;
  final MarkAllAdminNotificationsReadUseCase _markAllReadUseCase;

  RealtimeChannel? _notesChannel;
  Timer? _debounce;
  String? _currentAdminId;

  AdminNotificationsCubit(
    this._getUseCase,
    this._markReadUseCase,
    this._markAllReadUseCase,
  ) : super(AdminNotificationsInitial());

  void _subscribeToRealtime(String adminId) {
    _notesChannel?.unsubscribe();
    _notesChannel = Supabase.instance.client
        .channel('admin_notes_$adminId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'admin_notes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'admin_id',
            value: adminId,
          ),
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();
  }

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_currentAdminId != null) loadNotifications(_currentAdminId!);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _notesChannel?.unsubscribe();
    return super.close();
  }

  Future<void> loadNotifications(String adminId) async {
    if (_currentAdminId != adminId) {
      _currentAdminId = adminId;
      _subscribeToRealtime(adminId);
    }
    emit(AdminNotificationsLoading());
    final result = await _getUseCase(adminId);
    result.fold(
      (failure) => emit(AdminNotificationsError(failure.message)),
      (notes) => emit(AdminNotificationsLoaded(notes)),
    );
  }

  Future<void> markAsRead(String noteId) async {
    final result = await _markReadUseCase(noteId);
    result.fold(
      (failure) => emit(AdminNotificationsError(failure.message)),
      (_) {
        final current = state;
        if (current is AdminNotificationsLoaded) {
          final updated = current.notifications
              .map((n) => n.id == noteId ? n.copyWith(isRead: true) : n)
              .toList();
          emit(AdminNotificationsLoaded(updated));
        }
      },
    );
  }

  Future<void> markAllAsRead(String adminId) async {
    final result = await _markAllReadUseCase(adminId);
    result.fold(
      (failure) => emit(AdminNotificationsError(failure.message)),
      (_) {
        final current = state;
        if (current is AdminNotificationsLoaded) {
          final updated = current.notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();
          emit(AdminNotificationsLoaded(updated));
        }
      },
    );
  }
}
