import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getTodayTasks(String userId, {bool skipCache = false});
  Future<List<TaskModel>> getCompletedTasks(String userId, {bool skipCache = false});
  Future<TasksStatsModel> getTasksStats(String userId, {bool skipCache = false});
}
