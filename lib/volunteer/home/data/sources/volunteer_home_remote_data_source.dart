
import 'package:t3afy/volunteer/models/volunteer_stats_model.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';

abstract class VolunteerHomeRemoteDataSource {
  Future<VolunteerStatsModel> getVolunteerStats(String userId);
  Future<List<TaskModel>> getTodayTasks(String userId);
}