import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getTodayTasks(String userId);
  Future<List<TaskModel>> getCompletedTasks(String userId);
  Future<TasksStatsModel> getTasksStats(String userId);
}