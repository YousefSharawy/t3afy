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
}
