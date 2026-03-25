import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';

abstract class NotificationsRepository {
  Future<Either<Failture, List<AdminNote>>> getNotifications(
      String volunteerId);
  Future<Either<Failture, void>> markAsRead(String noteId);
  Future<Either<Failture, void>> markAllAsRead(String volunteerId);
  Future<Either<Failture, void>> clearAllNotifications(String volunteerId);
}
