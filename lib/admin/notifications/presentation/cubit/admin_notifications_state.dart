part of 'admin_notifications_cubit.dart';

abstract class AdminNotificationsState {}

class AdminNotificationsInitial extends AdminNotificationsState {}

class AdminNotificationsLoading extends AdminNotificationsState {}

class AdminNotificationsLoaded extends AdminNotificationsState {
  final List<AdminNotification> notifications;
  AdminNotificationsLoaded(this.notifications);
}

class AdminNotificationsError extends AdminNotificationsState {
  final String message;
  AdminNotificationsError(this.message);
}
