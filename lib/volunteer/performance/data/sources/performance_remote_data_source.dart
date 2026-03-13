import 'package:t3afy/volunteer/performance/data/models/performance_models.dart';

abstract class PerformanceRemoteDataSource {
  Future<(PerformanceStatsModel, double)> getPerformanceStats(String userId);
  Future<List<MonthlyHoursModel>> getMonthlyHours(String userId);
  Future<List<LeaderboardEntryModel>> getLeaderboard();
}
