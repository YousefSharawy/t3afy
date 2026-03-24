import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class EditVolunteerDataUsecase {
  final VolunteersRepo _repo;

  EditVolunteerDataUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String volunteerId,
    required Map<String, dynamic> fields,
  }) {
    return _repo.editVolunteerData(
      volunteerId: volunteerId,
      fields: fields,
    );
  }
}
