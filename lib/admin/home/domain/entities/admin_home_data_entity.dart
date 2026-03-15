import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';

class AdminHomeDataEntity {
  final String adminName;
  final String? adminAvatar;
  final int activeTodayCount;
  final int totalVolunteers;
  final int completedCampaigns;
  final double totalHours;
  final List<TodayCampaignEntity> todayCampaigns;

  const AdminHomeDataEntity({
    required this.adminName,
    this.adminAvatar,
    required this.activeTodayCount,
    required this.totalVolunteers,
    required this.completedCampaigns,
    required this.totalHours,
    required this.todayCampaigns,
  });
}
