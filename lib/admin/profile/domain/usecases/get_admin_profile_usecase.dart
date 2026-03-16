import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/domain/repos/admin_profile_repo.dart';

class GetAdminProfileUsecase {
  final AdminProfileRepo _repo;

  GetAdminProfileUsecase(this._repo);

  Future<Either<Failture, AdminProfileEntity>> call(String userId) {
    return _repo.getProfile(userId);
  }
}
