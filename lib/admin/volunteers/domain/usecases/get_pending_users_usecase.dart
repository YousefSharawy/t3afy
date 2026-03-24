import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class GetPendingUsersUsecase {
  final VolunteersRepo _repo;

  GetPendingUsersUsecase(this._repo);

  Future<Either<Failture, List<AdminVolunteerEntity>>> call() {
    return _repo.getPendingUsers();
  }
}
