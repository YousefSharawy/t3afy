import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<AdminNote>> getNotifications(String volunteerId);
  Future<void> markAsRead(String noteId);
  Future<void> markAllAsRead(String volunteerId);
  Future<void> clearAllNotifications(String volunteerId);
}
