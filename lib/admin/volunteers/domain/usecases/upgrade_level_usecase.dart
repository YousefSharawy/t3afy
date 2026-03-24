import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class UpgradeLevelUsecase {
  final VolunteersRepo _repo;

  UpgradeLevelUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String volunteerId,
    required int level,
    required String levelTitle,
  }) {
    return _repo.upgradeLevel(
      volunteerId: volunteerId,
      level: level,
      levelTitle: levelTitle,
    );
  }
}
