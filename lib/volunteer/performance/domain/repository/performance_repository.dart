import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

abstract class PerformanceRepository {
  Future<Either<Failture, PerformanceStatsEntity>> getPerformanceStats(
    String userId,
  );
  Future<Either<Failture, List<MonthlyHoursEntity>>> getMonthlyHours(
    String userId,
  );
  Future<Either<Failture, List<LeaderboardEntryEntity>>> getLeaderboard();
}
