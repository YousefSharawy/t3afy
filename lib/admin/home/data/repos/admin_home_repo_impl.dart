import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/home/data/datasources/admin_home_remote_datasource.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/admin/home/domain/repos/admin_home_repo.dart';

class AdminHomeRepoImpl implements AdminHomeRepo {
  final AdminHomeRemoteDatasource _datasource;

  AdminHomeRepoImpl(this._datasource);

  @override
  Future<Either<Failture, AdminHomeDataEntity>> getDashboardData(
      String adminId) async {
    try {
      final data = await _datasource.getDashboardData(adminId);
      return Right(data);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> sendAnnouncement({
    required String title,
    required String body,
    required String adminId,
  }) async {
    try {
      await _datasource.sendAnnouncement(
        title: title,
        body: body,
        adminId: adminId,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
