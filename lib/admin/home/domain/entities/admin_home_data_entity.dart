import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';

class MonthlyTaskCount {
  final DateTime month;
  final int count;

  const MonthlyTaskCount({required this.month, required this.count});
}

class AdminHomeDataEntity {
  final String adminName;
  final String? adminAvatar;
  final int activeTodayCount;
  final int totalVolunteers;
  final int completedCampaigns;
  final double totalHours;
  final List<TodayCampaignEntity> todayCampaigns;
  final List<MonthlyTaskCount> monthlyCompletedTasks;
  final int volunteersThisMonth;
  final int activeDiffFromYesterday;
  final int hoursPercentChange;

  const AdminHomeDataEntity({
    required this.adminName,
    this.adminAvatar,
    required this.activeTodayCount,
    required this.totalVolunteers,
    required this.completedCampaigns,
    required this.totalHours,
    required this.todayCampaigns,
    this.monthlyCompletedTasks = const [],
    this.volunteersThisMonth = 0,
    this.activeDiffFromYesterday = 0,
    this.hoursPercentChange = 0,
  });
}
