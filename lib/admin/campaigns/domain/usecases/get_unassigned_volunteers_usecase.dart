import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../entities/volunteer_entity.dart';
import '../repos/campaigns_repo.dart';

class GetUnassignedVolunteersUsecase {
  final CampaignsRepo _repo;
  GetUnassignedVolunteersUsecase(this._repo);

  Future<Either<Failture, List<VolunteerEntity>>> call(String taskId) =>
      _repo.getUnassignedVolunteers(taskId);
}
