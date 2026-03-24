import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_all_as_read_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_as_read_use_case.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;

  RealtimeChannel? _notesChannel;
  Timer? _debounce;
  String? _currentVolunteerId;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._markAsReadUseCase,
    this._markAllAsReadUseCase,
  ) : super(NotificationsStateInitial());

  void _subscribeToRealtime(String volunteerId) {
    _notesChannel?.unsubscribe();
    _notesChannel = Supabase.instance.client
        .channel('volunteer_notes_$volunteerId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'admin_notes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'volunteer_id',
            value: volunteerId,
          ),
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();
  }

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_currentVolunteerId != null) loadNotifications(_currentVolunteerId!);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _notesChannel?.unsubscribe();
    return super.close();
  }

  Future<void> loadNotifications(String volunteerId) async {
    if (_currentVolunteerId != volunteerId) {
      _currentVolunteerId = volunteerId;
      _subscribeToRealtime(volunteerId);
    }
    emit(NotificationsStateLoading());
    final result = await _getNotificationsUseCase(volunteerId);
    result.fold(
      (failure) => emit(NotificationsStateError(failure.message)),
      (notes) => emit(NotificationsStateLoaded(notes)),
    );
  }

  Future<void> markAsRead(String noteId) async {
    final result = await _markAsReadUseCase(noteId);
    result.fold(
      (failure) => emit(NotificationsStateError(failure.message)),
      (_) {
        final currentState = state;
        if (currentState is NotificationsStateLoaded) {
          final updatedNotes = currentState.notes.map((note) {
            if (note.id == noteId) {
              return AdminNote(
                id: note.id,
                volunteerId: note.volunteerId,
                title: note.title,
                message: note.message,
                isRead: true,
                createdAt: note.createdAt,
              );
            }
            return note;
          }).toList();
          emit(NotificationsStateLoaded(updatedNotes));
        }
      },
    );
  }

  Future<void> markAllAsRead(String volunteerId) async {
    final result = await _markAllAsReadUseCase(volunteerId);
    result.fold(
      (failure) => emit(NotificationsStateError(failure.message)),
      (_) {
        final currentState = state;
        if (currentState is NotificationsStateLoaded) {
          final updatedNotes = currentState.notes.map((note) {
            return AdminNote(
              id: note.id,
              volunteerId: note.volunteerId,
              title: note.title,
              message: note.message,
              isRead: true,
              createdAt: note.createdAt,
            );
          }).toList();
          emit(NotificationsStateLoaded(updatedNotes));
        }
      },
    );
  }
}
