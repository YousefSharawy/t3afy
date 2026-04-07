import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class SendTeamAlertUsecase {
  final CampaignsRepo _repo;
  SendTeamAlertUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  }) => _repo.sendTeamAlert(
    taskId: taskId,
    adminId: adminId,
    title: title,
    body: body,
    volunteerIds: volunteerIds,
  );
}
