import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/notifications/domain/repository/notifications_repository.dart';

class MarkAllAsReadUseCase {
  final NotificationsRepository _repo;

  MarkAllAsReadUseCase(this._repo);

  Future<Either<Failture, void>> call(String volunteerId) =>
      _repo.markAllAsRead(volunteerId);
}
