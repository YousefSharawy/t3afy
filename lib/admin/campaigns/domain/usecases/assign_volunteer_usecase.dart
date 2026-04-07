import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class AssignVolunteerUsecase {
  final CampaignsRepo _repo;
  AssignVolunteerUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String taskId,
    required List<String> userIds,
    required String adminId,
  }) => _repo.assignVolunteers(
    taskId: taskId,
    userIds: userIds,
    adminId: adminId,
  );
}
