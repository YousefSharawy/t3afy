part of 'notifications_cubit.dart';

abstract class NotificationsState {}

class NotificationsStateInitial extends NotificationsState {}

class NotificationsStateLoading extends NotificationsState {}

class NotificationsStateLoaded extends NotificationsState {
  final List<AdminNote> notes;

  NotificationsStateLoaded(this.notes);
}

class NotificationsStateError extends NotificationsState {
  final String message;

  NotificationsStateError(this.message);
}
