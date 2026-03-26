class RegionStatEntity {
  final String region;
  final int volunteerCount;

  const RegionStatEntity({required this.region, required this.volunteerCount});
}

/// A single bar in the performance chart with a display label.
class PerformanceBarEntry {
  final String label;
  final int count;

  const PerformanceBarEntry({required this.label, required this.count});
}

class AdminPerformanceEntity {
  final int totalVolunteers;
  final int totalHours;
  final double avgRating;
  final List<PerformanceBarEntry> chartBars;
  final List<RegionStatEntity> topRegions;
  final int totalCampaigns;
  final int completedCampaigns;
  final double campaignCompletionPercent;
  final double completionPercentChange;
  final double verifiedAttendanceRate;

  const AdminPerformanceEntity({
    required this.totalVolunteers,
    required this.totalHours,
    required this.avgRating,
    required this.chartBars,
    required this.topRegions,
    required this.totalCampaigns,
    required this.completedCampaigns,
    required this.campaignCompletionPercent,
    required this.completionPercentChange,
    this.verifiedAttendanceRate = 0,
  });
}
