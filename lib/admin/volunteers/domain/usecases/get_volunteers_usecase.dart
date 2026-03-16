import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class GetVolunteersUsecase {
  final VolunteersRepo _repo;

  GetVolunteersUsecase(this._repo);

  Future<Either<Failture, List<AdminVolunteerEntity>>> call() {
    return _repo.getVolunteers();
  }
}
