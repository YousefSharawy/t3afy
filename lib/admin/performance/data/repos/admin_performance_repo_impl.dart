import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/performance/data/datasources/admin_performance_remote_datasource.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/admin/performance/domain/repos/admin_performance_repo.dart';

class AdminPerformanceRepoImpl implements AdminPerformanceRepo {
  final AdminPerformanceRemoteDatasource _datasource;

  AdminPerformanceRepoImpl(this._datasource);

  @override
  Future<Either<Failture, AdminPerformanceEntity>> getPerformanceData(
    DateTime startDate,
    String period,
  ) async {
    try {
      final data = await _datasource.getPerformanceData(startDate, period);
      return Right(data);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
