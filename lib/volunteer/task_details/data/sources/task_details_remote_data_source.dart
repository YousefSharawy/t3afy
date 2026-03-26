import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';

import '../models/task_details_model.dart';
import '../models/task_objective_model.dart';
import '../models/task_supply_model.dart';

abstract class TaskDetailsRemoteDataSource {
  Future<TaskDetailsModel> getTaskDetails(String taskId);
  Future<List<TaskObjectiveModel>> getTaskObjectives(String taskId);
  Future<List<TaskSupplyModel>> getTaskSupplies(String taskId);
  Future<List<CampaignPaperEntity>> getTaskPapers(String taskId);
  RealtimeChannel subscribeToTask(
    String taskId,
    void Function(Map<String, dynamic>) onUpdate,
  );
  RealtimeChannel subscribeToAssignment(
    String taskId,
    void Function(Map<String, dynamic>) onUpdate,
  );
  Future<void> unsubscribe(RealtimeChannel channel);
}
