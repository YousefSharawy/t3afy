import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class AssignVolunteerUsecase {
  final CampaignsRepo _repo;
  AssignVolunteerUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String taskId,
    required String userId,
    required String adminId,
  }) =>
      _repo.assignVolunteer(taskId: taskId, userId: userId, adminId: adminId);
}
