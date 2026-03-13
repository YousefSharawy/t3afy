import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/performance/data/mappers/performance_mappers.dart';
import 'package:t3afy/volunteer/performance/data/sources/performance_remote_data_source.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/volunteer/performance/domain/repository/performance_repository.dart';

class PerformanceImplRepository implements PerformanceRepository {
  final PerformanceRemoteDataSource _dataSource;

  PerformanceImplRepository(this._dataSource);

  @override
  Future<Either<Failture, PerformanceStatsEntity>> getPerformanceStats(
    String userId,
  ) async {
    try {
      final (stats, commitmentPct) =
          await _dataSource.getPerformanceStats(userId);
      return Right(stats.toEntity(commitmentPct: commitmentPct));
    } on Failture catch (failture) {
      return Left(failture);
    }
  }

  @override
  Future<Either<Failture, List<MonthlyHoursEntity>>> getMonthlyHours(
    String userId,
  ) async {
    try {
      final result = await _dataSource.getMonthlyHours(userId);
      return Right(result.map((m) => m.toEntity()).toList());
    } on Failture catch (failture) {
      return Left(failture);
    }
  }

  @override
  Future<Either<Failture, List<LeaderboardEntryEntity>>> getLeaderboard() async {
    try {
      final result = await _dataSource.getLeaderboard();
      return Right(result.map((e) => e.toEntity()).toList());
    } on Failture catch (failture) {
      return Left(failture);
    }
  }
}
