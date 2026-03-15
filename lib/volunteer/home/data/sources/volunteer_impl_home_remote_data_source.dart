import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/volunteer/home/data/sources/volunteer_home_remote_data_source.dart';
import 'package:t3afy/volunteer/models/volunteer_stats_model.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';

class VolunteerImplHomeRemoteDataSource implements VolunteerHomeRemoteDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<VolunteerStatsModel> getVolunteerStats(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select(
            'id, name, email, phone, avatar_url, level, level_title, rating, total_hours, total_tasks, places_visited',
          )
          .eq('id', userId)
          .single();
      return VolunteerStatsModel.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<TaskModel>> getTodayTasks(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T').first;

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

      return (response as List).map<TaskModel>((row) {
        final task = row['tasks'] as Map<String, dynamic>;
        return TaskModel.fromJson({
          ...task,
          'assignment_status': row['status'] ?? 'assigned',
        });
      }).toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}