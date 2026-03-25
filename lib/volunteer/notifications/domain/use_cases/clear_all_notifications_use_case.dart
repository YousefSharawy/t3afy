import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/notifications/domain/repository/notifications_repository.dart';

class ClearAllNotificationsUseCase {
  final NotificationsRepository _repo;

  ClearAllNotificationsUseCase(this._repo);

  Future<Either<Failture, void>> call(String volunteerId) =>
      _repo.clearAllNotifications(volunteerId);
}
