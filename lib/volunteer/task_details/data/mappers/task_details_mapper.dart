import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';

import '../../domain/entities/task_details_entity.dart';
import '../../domain/entities/task_objective_entity.dart';
import '../../domain/entities/task_supply_entity.dart';
import '../models/task_details_model.dart';
import '../models/task_objective_model.dart';
import '../models/task_supply_model.dart';

extension TaskDetailsModelMapper on TaskDetailsModel {
  TaskDetailsEntity toEntity(
    List<TaskObjectiveEntity> objectives,
    List<TaskSupplyEntity> supplies, {
    List<CampaignPaperEntity> papers = const [],
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    double? verifiedHours,
    bool isVerified = false,
  }) {
    return TaskDetailsEntity(
      id: id,
      title: title,
      type: type,
      description: description,
      status: status,
      date: date,
      timeStart: timeStart,
      timeEnd: timeEnd,
      durationHours: durationHours,
      points: points,
      locationName: locationName,
      locationAddress: locationAddress,
      locationLat: locationLat,
      locationLng: locationLng,
      supervisorName: supervisorName,
      supervisorPhone: supervisorPhone,
      notes: notes,
      assignmentStatus: assignmentStatus,
      checkedInAt: checkedInAt,
      checkedOutAt: checkedOutAt,
      verifiedHours: verifiedHours,
      isVerified: isVerified,
      objectives: objectives,
      supplies: supplies,
      papers: papers,
    );
  }
}

extension TaskObjectiveModelMapper on TaskObjectiveModel {
  TaskObjectiveEntity toEntity() {
    return TaskObjectiveEntity(id: id, title: title, orderIndex: orderIndex);
  }
}

extension TaskSupplyModelMapper on TaskSupplyModel {
  TaskSupplyEntity toEntity() {
    return TaskSupplyEntity(id: id, name: name, quantity: quantity);
  }
}
