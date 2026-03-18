import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';
import 'package:t3afy/volunteer/tasks/data/sources/tasks_remote_data_source.dart';

class TasksImplRemoteDataSource implements TasksRemoteDataSource {
  final SupabaseClient _client;

  TasksImplRemoteDataSource(this._client);

  @override
  Future<List<TaskModel>> getTodayTasks(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final cacheKey = 'today_tasks_${userId}_$today';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map<TaskModel>((e) =>
                TaskModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }

      final response = await _client
          .from('task_assignments')
          .select('''
          status,
          tasks!inner(
            id, title, type, description, status, date,
            time_start, time_end, duration_hours, points,
            location_name, location_address, location_lat, location_lng,
            supervisor_name, supervisor_phone, notes
          )
        ''')
          .eq('user_id', userId)
          .eq('tasks.date', today);

      final tasks = response.map<TaskModel>((row) {
        final task = row['tasks'] as Map<String, dynamic>;
        return TaskModel.fromJson({
          ...task,
          'assignment_status': row['status'] ?? 'assigned',
        });
      }).toList();

      await LocalAppStorage.setCache(
          cacheKey, tasks.map((t) => t.toJson()).toList(),
          ttl: const Duration(minutes: 2));
      return tasks;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<List<TaskModel>> getCompletedTasks(String userId) async {
    try {
      final cacheKey = 'completed_tasks_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map<TaskModel>((e) =>
                TaskModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }

      final response = await _client
          .from('task_assignments')
          .select('''
            status,
            tasks!inner(
              id, title, type, description, status, date,
              time_start, time_end, duration_hours, points,
              location_name, location_address, location_lat, location_lng,
              supervisor_name, supervisor_phone, notes
            )
          ''')
          .eq('user_id', userId)
          .eq('status', 'completed')
          .order('assigned_at', ascending: false);

      final tasks = response.map<TaskModel>((row) {
        final task = row['tasks'] as Map<String, dynamic>;
        return TaskModel.fromJson({
          ...task,
          'assignment_status': 'completed',
        });
      }).toList();

      await LocalAppStorage.setCache(
          cacheKey, tasks.map((t) => t.toJson()).toList(),
          ttl: const Duration(minutes: 5));
      return tasks;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<TasksStatsModel> getTasksStats(String userId) async {
    try {
      final cacheKey = 'tasks_stats_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        final m = Map<String, dynamic>.from(cached as Map);
        return TasksStatsModel(
          todayCount: m['today_count'] as int,
          completedCount: m['completed_count'] as int,
          earnedPoints: m['earned_points'] as int,
        );
      }

      final today = DateTime.now().toIso8601String().split('T')[0];

      final todayResponse = await _client
          .from('task_assignments')
          .select('id, tasks!inner(date)')
          .eq('user_id', userId)
          .eq('tasks.date', today);
      final todayCount = todayResponse.length;

      final completedResponse = await _client
          .from('task_assignments')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'completed');
      final completedCount = completedResponse.length;

      final pointsResponse = await _client
          .from('task_assignments')
          .select('tasks!inner(points)')
          .eq('user_id', userId)
          .eq('status', 'completed');
      int earnedPoints = 0;
      for (final row in pointsResponse) {
        earnedPoints += (row['tasks']['points'] as num?)?.toInt() ?? 0;
      }

      await LocalAppStorage.setCache(
        cacheKey,
        {
          'today_count': todayCount,
          'completed_count': completedCount,
          'earned_points': earnedPoints,
        },
        ttl: const Duration(minutes: 5),
      );

      return TasksStatsModel(
        todayCount: todayCount,
        completedCount: completedCount,
        earnedPoints: earnedPoints,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
