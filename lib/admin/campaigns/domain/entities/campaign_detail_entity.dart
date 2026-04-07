import 'campaign_member_entity.dart';
import 'campaign_objective_entity.dart';
import 'campaign_paper_entity.dart';
import 'campaign_supply_entity.dart';

class CampaignDetailEntity {
  final String id;
  final String title;
  final String type;
  final String status;
  final String date;
  final String? timeStart;
  final String? timeEnd;
  final String? locationName;
  final String? locationAddress;
  final double? locationLat;
  final double? locationLng;
  final String? supervisorName;
  final String? supervisorPhone;
  final String? description;
  final String? notes;
  final int targetBeneficiaries;
  final int reachedBeneficiaries;
  final int points;
  final int verifiedAttendanceCount;
  final double totalVerifiedHours;
  final List<CampaignMemberEntity> members;
  final List<CampaignObjectiveEntity> objectives;
  final List<CampaignSupplyEntity> supplies;
  final List<CampaignPaperEntity> papers;

  const CampaignDetailEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
    this.timeStart,
    this.timeEnd,
    this.locationName,
    this.locationAddress,
    this.locationLat,
    this.locationLng,
    this.supervisorName,
    this.supervisorPhone,
    this.description,
    this.notes,
    required this.targetBeneficiaries,
    required this.reachedBeneficiaries,
    required this.points,
    this.verifiedAttendanceCount = 0,
    this.totalVerifiedHours = 0.0,
    required this.members,
    required this.objectives,
    required this.supplies,
    this.papers = const [],
  });

  /// Task expected duration in decimal hours, derived from timeStart/timeEnd.
  double get durationHours {
    if (timeStart == null || timeEnd == null) return 0;
    try {
      final sParts = timeStart!.split(':');
      final eParts = timeEnd!.split(':');
      final startMinutes = int.parse(sParts[0]) * 60 + int.parse(sParts[1]);
      final endMinutes = int.parse(eParts[0]) * 60 + int.parse(eParts[1]);
      final diff = endMinutes - startMinutes;
      return diff > 0 ? diff / 60.0 : 0;
    } catch (_) {
      return 0;
    }
  }

  double get attendanceRate =>
      members.isEmpty ? 0 : (verifiedAttendanceCount / members.length) * 100;

  CampaignDetailEntity copyWith({
    String? id,
    String? title,
    String? type,
    String? status,
    String? date,
    String? timeStart,
    String? timeEnd,
    String? locationName,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    String? supervisorName,
    String? supervisorPhone,
    String? description,
    String? notes,
    int? targetBeneficiaries,
    int? reachedBeneficiaries,
    int? points,
    int? verifiedAttendanceCount,
    double? totalVerifiedHours,
    List<CampaignMemberEntity>? members,
    List<CampaignObjectiveEntity>? objectives,
    List<CampaignSupplyEntity>? supplies,
    List<CampaignPaperEntity>? papers,
  }) {
    return CampaignDetailEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      supervisorName: supervisorName ?? this.supervisorName,
      supervisorPhone: supervisorPhone ?? this.supervisorPhone,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      targetBeneficiaries: targetBeneficiaries ?? this.targetBeneficiaries,
      reachedBeneficiaries: reachedBeneficiaries ?? this.reachedBeneficiaries,
      points: points ?? this.points,
      verifiedAttendanceCount:
          verifiedAttendanceCount ?? this.verifiedAttendanceCount,
      totalVerifiedHours: totalVerifiedHours ?? this.totalVerifiedHours,
      members: members ?? this.members,
      objectives: objectives ?? this.objectives,
      supplies: supplies ?? this.supplies,
      papers: papers ?? this.papers,
    );
  }
}
