import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class DeleteVolunteerUsecase {
  final VolunteersRepo _repo;

  DeleteVolunteerUsecase(this._repo);

  Future<Either<Failture, void>> call(String volunteerId) {
    return _repo.deleteVolunteer(volunteerId);
  }
}
