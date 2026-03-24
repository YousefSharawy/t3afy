import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';

abstract class AdminNotificationsRepository {
  Future<Either<Failture, List<AdminNotification>>> getNotifications(
      String adminId);
  Future<Either<Failture, void>> markAsRead(String noteId);
  Future<Either<Failture, void>> markAllAsRead(String adminId);
}
