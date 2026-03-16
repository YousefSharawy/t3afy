import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/profile/domain/repos/admin_profile_repo.dart';

class UpdateAdminProfileUsecase {
  final AdminProfileRepo _repo;

  UpdateAdminProfileUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  }) {
    return _repo.updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      email: email,
    );
  }
}
