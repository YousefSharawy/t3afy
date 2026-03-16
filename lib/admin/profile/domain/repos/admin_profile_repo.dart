import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';

abstract class AdminProfileRepo {
  Future<Either<Failture, AdminProfileEntity>> getProfile(String userId);
  Future<Either<Failture, void>> updateProfile({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  });
}
