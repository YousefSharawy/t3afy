import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart'
    show MonthlyTaskCount;

class RegionStatEntity {
  final String region;
  final int volunteerCount;

  const RegionStatEntity({required this.region, required this.volunteerCount});
}

class AdminPerformanceEntity {
  final int totalVolunteers;
  final int totalHours;
  final double avgRating;
  final List<MonthlyTaskCount> monthlyCompletedTasks;
  final List<RegionStatEntity> topRegions;
  final int totalCampaigns;
  final int completedCampaigns;
  final double campaignCompletionPercent;
  final double completionPercentChange;

  const AdminPerformanceEntity({
    required this.totalVolunteers,
    required this.totalHours,
    required this.avgRating,
    required this.monthlyCompletedTasks,
    required this.topRegions,
    required this.totalCampaigns,
    required this.completedCampaigns,
    required this.campaignCompletionPercent,
    required this.completionPercentChange,
  });
}
