import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/notifications/domain/repository/admin_notifications_repository.dart';

class MarkAllAdminNotificationsReadUseCase {
  final AdminNotificationsRepository _repo;

  MarkAllAdminNotificationsReadUseCase(this._repo);

  Future<Either<Failture, void>> call(String adminId) =>
      _repo.markAllAsRead(adminId);
}
