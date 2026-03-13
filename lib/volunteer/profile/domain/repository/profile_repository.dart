import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failture, ProfileEntity>> getProfile(String userId);
}