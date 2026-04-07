import 'package:t3afy/volunteer/performance/data/models/performance_models.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

extension PerformanceStatsMapper on PerformanceStatsModel {
  PerformanceStatsEntity toEntity({required double commitmentPct}) {
    return PerformanceStatsEntity(
      name: name,
      avatarUrl: avatarUrl,
      rating: rating,
      level: level,
      levelTitle: levelTitle,
      totalHours: totalHours,
      placesVisited: placesVisited,
      totalPoints: totalPoints,
      commitmentPct: commitmentPct,
    );
  }
}

extension MonthlyHoursMapper on MonthlyHoursModel {
  MonthlyHoursEntity toEntity() {
    return MonthlyHoursEntity(year: year, month: month, hours: hours);
  }
}

extension LeaderboardEntryMapper on LeaderboardEntryModel {
  LeaderboardEntryEntity toEntity() {
    return LeaderboardEntryEntity(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      totalHours: totalHours,
      pts: pts,
    );
  }
}
