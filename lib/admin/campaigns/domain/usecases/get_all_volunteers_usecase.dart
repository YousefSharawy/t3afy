import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../entities/volunteer_entity.dart';
import '../repos/campaigns_repo.dart';

class GetAllVolunteersUsecase {
  final CampaignsRepo _repo;
  GetAllVolunteersUsecase(this._repo);

  Future<Either<Failture, List<VolunteerEntity>>> call() =>
      _repo.getAllVolunteers();
}
