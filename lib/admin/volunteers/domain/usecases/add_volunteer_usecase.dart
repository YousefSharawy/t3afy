import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class AddVolunteerUsecase {
  final VolunteersRepo _repo;

  AddVolunteerUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  }) =>
      _repo.addVolunteer(
        name: name,
        email: email,
        phone: phone,
        region: region,
        qualification: qualification,
      );
}
