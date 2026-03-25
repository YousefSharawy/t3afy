import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/volunteer/home/data/sources/volunteer_home_remote_data_source.dart';
import 'package:t3afy/volunteer/models/volunteer_stats_model.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';

class VolunteerImplHomeRemoteDataSource implements VolunteerHomeRemoteDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<VolunteerStatsModel> getVolunteerStats(String userId) async {
    try {
      const ttl = Duration(seconds: 30);
      final cacheKey = 'vol_stats_v2_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return VolunteerStatsModel.fromJson(
            Map<String, dynamic>.from(cached as Map));
      }

      final response = await _client
          .from('users')
          .select(
            'id, name, email, phone, avatar_url, level, level_title, rating, total_hours, total_tasks, places_visited, total_points',
          )
          .eq('id', userId)
          .single();
      await LocalAppStorage.setCache(cacheKey, response, ttl: ttl);
      return VolunteerStatsModel.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<TaskModel>> getTodayTasks(String userId) async {
    try {
      const ttl = Duration(seconds: 30);
      final today = DateTime.now().toIso8601String().split('T').first;
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
          .eq('tasks.date', today)
          .not('status', 'in', '("completed","missed")');

      final tasks = (response as List).map<TaskModel>((row) {
        final task = row['tasks'] as Map<String, dynamic>;
        final assignmentStatus = resolveAssignmentStatus(
          row['status'] as String? ?? 'assigned',
          task['date'] as String?,
          task['time_end'] as String?,
        );
        return TaskModel.fromJson({
          ...task,
          'assignment_status': assignmentStatus,
        });
      }).toList();

      await LocalAppStorage.setCache(
          cacheKey, tasks.map((t) => t.toJson()).toList(),
          ttl: ttl);
      return tasks;
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<int> getUnreadNotificationsCount(String userId) async {
    try {
      final res = await _client
          .from('admin_notes')
          .select('id')
          .eq('volunteer_id', userId)
          .eq('is_read', false);
      return (res as List).length;
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}
