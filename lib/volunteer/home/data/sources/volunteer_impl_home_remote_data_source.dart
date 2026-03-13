import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/volunteer/home/data/sources/volunteer_home_remote_data_source.dart';
import 'package:t3afy/volunteer/models/volunteer_stats_model.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_model.dart';

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

      final assignments = await _client
          .from('task_assignments')
          .select('task_id')
          .eq('user_id', userId);

      final taskIds =
          (assignments as List).map((a) => a['task_id'] as String).toList();

      if (taskIds.isEmpty) return [];

      final response = await _client
          .from('tasks')
          .select()
          .inFilter('id', taskIds)
          .eq('date', today);

      return (response as List)
          .map((json) => TaskModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}