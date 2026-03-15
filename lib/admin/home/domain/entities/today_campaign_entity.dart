class TodayCampaignEntity {
  final String id;
  final String title;
  final String type;
  final String status;
  final String timeStart;
  final String timeEnd;
  final String? locationName;
  final String? supervisorName;
  final int volunteerCount;
  final int? targetBeneficiaries;
  final int? reachedBeneficiaries;

  const TodayCampaignEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.timeStart,
    required this.timeEnd,
    this.locationName,
    this.supervisorName,
    required this.volunteerCount,
    this.targetBeneficiaries,
    this.reachedBeneficiaries,
  });
}
