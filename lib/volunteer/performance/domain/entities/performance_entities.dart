class PerformanceStatsEntity {
  final String name;
  final String avatarUrl;
  final double rating;
  final int level;
  final String levelTitle;
  final int totalHours;
  final int placesVisited;
  final int totalPoints;
  final double commitmentPct;

  PerformanceStatsEntity({
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.level,
    required this.levelTitle,
    required this.totalHours,
    required this.placesVisited,
    required this.totalPoints,
    required this.commitmentPct,
  });
}

class MonthlyHoursEntity {
  final int year;
  final int month;
  final double hours;

  MonthlyHoursEntity({
    required this.year,
    required this.month,
    required this.hours,
  });
}

class LeaderboardEntryEntity {
  final String id;
  final String name;
  final String avatarUrl;
  final int totalHours;
  final int pts;

  LeaderboardEntryEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.totalHours,
    required this.pts,
  });
}
