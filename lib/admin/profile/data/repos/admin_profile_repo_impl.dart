import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/profile/data/datasources/admin_profile_remote_datasource.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/domain/repos/admin_profile_repo.dart';

class AdminProfileRepoImpl implements AdminProfileRepo {
  final AdminProfileRemoteDatasource _datasource;

  AdminProfileRepoImpl(this._datasource);

  @override
  Future<Either<Failture, AdminProfileEntity>> getProfile(String userId) async {
    try {
      final result = await _datasource.getProfile(userId);
      return Right(result);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> updateProfile({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  }) async {
    try {
      await _datasource.updateProfile(
        userId: userId,
        name: name,
        phone: phone,
        email: email,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
