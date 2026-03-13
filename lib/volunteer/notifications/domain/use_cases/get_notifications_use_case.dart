import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';
import 'package:t3afy/volunteer/notifications/domain/repository/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository _repo;

  GetNotificationsUseCase(this._repo);

  Future<Either<Failture, List<AdminNote>>> call(String volunteerId) =>
      _repo.getNotifications(volunteerId);
}
