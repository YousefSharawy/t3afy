import 'campaign_member_entity.dart';
import 'campaign_objective_entity.dart';
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
  final String? supervisorName;
  final String? supervisorPhone;
  final String? description;
  final String? notes;
  final int targetBeneficiaries;
  final int reachedBeneficiaries;
  final int points;
  final List<CampaignMemberEntity> members;
  final List<CampaignObjectiveEntity> objectives;
  final List<CampaignSupplyEntity> supplies;

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
    this.supervisorName,
    this.supervisorPhone,
    this.description,
    this.notes,
    required this.targetBeneficiaries,
    required this.reachedBeneficiaries,
    required this.points,
    required this.members,
    required this.objectives,
    required this.supplies,
  });

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
    String? supervisorName,
    String? supervisorPhone,
    String? description,
    String? notes,
    int? targetBeneficiaries,
    int? reachedBeneficiaries,
    int? points,
    List<CampaignMemberEntity>? members,
    List<CampaignObjectiveEntity>? objectives,
    List<CampaignSupplyEntity>? supplies,
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
      supervisorName: supervisorName ?? this.supervisorName,
      supervisorPhone: supervisorPhone ?? this.supervisorPhone,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      targetBeneficiaries: targetBeneficiaries ?? this.targetBeneficiaries,
      reachedBeneficiaries: reachedBeneficiaries ?? this.reachedBeneficiaries,
      points: points ?? this.points,
      members: members ?? this.members,
      objectives: objectives ?? this.objectives,
      supplies: supplies ?? this.supplies,
    );
  }
}
