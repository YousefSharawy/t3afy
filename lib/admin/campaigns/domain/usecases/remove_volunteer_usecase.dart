import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class RemoveVolunteerUsecase {
  final CampaignsRepo _repo;
  RemoveVolunteerUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String taskId,
    required String userId,
  }) => _repo.removeVolunteer(taskId: taskId, userId: userId);
}
