import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/notifications/domain/repository/notifications_repository.dart';

class MarkAsReadUseCase {
  final NotificationsRepository _repo;

  MarkAsReadUseCase(this._repo);

  Future<Either<Failture, void>> call(String noteId) =>
      _repo.markAsRead(noteId);
}
