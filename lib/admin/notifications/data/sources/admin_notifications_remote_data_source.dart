import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';

abstract class AdminNotificationsRemoteDataSource {
  Future<List<AdminNotification>> getNotifications(String adminId);
  Future<void> markAsRead(String noteId);
  Future<void> markAllAsRead(String adminId);
}
