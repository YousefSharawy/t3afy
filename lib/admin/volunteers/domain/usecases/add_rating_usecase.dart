import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class AddRatingUsecase {
  final VolunteersRepo _repo;

  AddRatingUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String adminId,
    required String volunteerId,
    required int rating,
    String? comment,
  }) {
    return _repo.addRating(
      adminId: adminId,
      volunteerId: volunteerId,
      rating: rating,
      comment: comment,
    );
  }
}
