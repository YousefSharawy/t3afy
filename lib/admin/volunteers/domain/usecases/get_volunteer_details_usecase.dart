import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class GetVolunteerDetailsUsecase {
  final VolunteersRepo _repo;

  GetVolunteerDetailsUsecase(this._repo);

  Future<Either<Failture, VolunteerDetailsEntity>> call(String volunteerId) {
    return _repo.getVolunteerDetails(volunteerId);
  }
}
