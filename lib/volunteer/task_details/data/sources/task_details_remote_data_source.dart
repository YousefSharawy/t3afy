import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';

import '../models/task_details_model.dart';
import '../models/task_objective_model.dart';
import '../models/task_supply_model.dart';

/// The task row plus the current volunteer's assignment row (check-in/out
/// columns), fetched in one query.
typedef TaskWithAssignment = ({
  TaskDetailsModel task,
  Map<String, dynamic>? assignment,
});

abstract class TaskDetailsRemoteDataSource {
  Future<TaskWithAssignment> getTaskDetails(String taskId);
  Future<List<TaskObjectiveModel>> getTaskObjectives(String taskId);
  Future<List<TaskSupplyModel>> getTaskSupplies(String taskId);
  Future<List<CampaignPaperEntity>> getTaskPapers(String taskId);
}
