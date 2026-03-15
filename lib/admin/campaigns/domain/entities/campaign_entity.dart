class CampaignEntity {
  final String id;
  final String title;
  final String type;
  final String status;
  final String date;
  final String? timeStart;
  final String? timeEnd;
  final String? locationName;
  final String? locationAddress;
  final String? supervisorName;
  final int volunteerCount;
  final int targetBeneficiaries;
  final int reachedBeneficiaries;
  final int points;

  const CampaignEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
    this.timeStart,
    this.timeEnd,
    this.locationName,
    this.locationAddress,
    this.supervisorName,
    required this.volunteerCount,
    required this.targetBeneficiaries,
    required this.reachedBeneficiaries,
    required this.points,
  });
}
