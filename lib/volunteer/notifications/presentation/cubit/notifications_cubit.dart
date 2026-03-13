import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_all_as_read_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_as_read_use_case.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._markAsReadUseCase,
    this._markAllAsReadUseCase,
  ) : super(NotificationsStateInitial());

  Future<void> loadNotifications(String volunteerId) async {
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
