import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';
import 'package:t3afy/admin/notifications/domain/repository/admin_notifications_repository.dart';

class GetAdminNotificationsUseCase {
  final AdminNotificationsRepository _repo;

  GetAdminNotificationsUseCase(this._repo);

  Future<Either<Failture, List<AdminNotification>>> call(String adminId) =>
      _repo.getNotifications(adminId);
}
