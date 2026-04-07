import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/domain/repository/profile_repository.dart';

class GetProfile {
  final ProfileRepository _repository;

  GetProfile(this._repository);

  Future<Either<Failture, ProfileEntity>> call(String userId) {
    return _repository.getProfile(userId);
  }
}
