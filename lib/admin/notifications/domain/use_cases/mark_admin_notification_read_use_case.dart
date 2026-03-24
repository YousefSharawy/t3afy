import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/notifications/domain/repository/admin_notifications_repository.dart';

class MarkAdminNotificationReadUseCase {
  final AdminNotificationsRepository _repo;

  MarkAdminNotificationReadUseCase(this._repo);

  Future<Either<Failture, void>> call(String noteId) =>
      _repo.markAsRead(noteId);
}
