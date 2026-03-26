import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';

import 'task_objective_entity.dart';
import 'task_supply_entity.dart';

class TaskDetailsEntity {
  final String id;
  final String title;
  final String type;
  final String? description;
  final String status;
  final String date;
  final String timeStart;
  final String timeEnd;
  final double? durationHours;
  final int points;
  final String? locationName;
  final String? locationAddress;
  final double? locationLat;
  final double? locationLng;
  final String? supervisorName;
  final String? supervisorPhone;
  final String? notes;
  final String? assignmentStatus;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;
  final double? verifiedHours;
  final bool isVerified;
  final List<TaskObjectiveEntity> objectives;
  final List<TaskSupplyEntity> supplies;
  final List<CampaignPaperEntity> papers;

  TaskDetailsEntity({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    required this.status,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    this.durationHours,
    required this.points,
    this.locationName,
    this.locationAddress,
    this.locationLat,
    this.locationLng,
    this.supervisorName,
    this.supervisorPhone,
    this.notes,
    this.assignmentStatus,
    this.checkedInAt,
    this.checkedOutAt,
    this.verifiedHours,
    this.isVerified = false,
    required this.objectives,
    required this.supplies,
    this.papers = const [],
  });
}
