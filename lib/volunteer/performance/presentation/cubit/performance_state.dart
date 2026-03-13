part of 'performance_cubit.dart';

@freezed
class PerformanceState with _$PerformanceState {
  const factory PerformanceState.initial() = _Initial;
  const factory PerformanceState.loading() = _Loading;
  const factory PerformanceState.loaded({
    required PerformanceStatsEntity stats,
    required List<MonthlyHoursEntity> monthlyHours,
    required List<LeaderboardEntryEntity> leaderboard,
    required String currentUserId,
  }) = _Loaded;
  const factory PerformanceState.error(String message) = _Error;
}
