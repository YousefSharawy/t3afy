import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';
import 'package:t3afy/volunteer/tasks/data/sources/tasks_remote_data_source.dart';

class TasksImplRemoteDataSource implements TasksRemoteDataSource {
  final SupabaseClient _client;

  TasksImplRemoteDataSource(this._client);

  @override
  Future<List<TaskModel>> getTodayTasks(
    String userId, {
    bool skipCache = false,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final cacheKey = 'today_tasks_${userId}_$today';
      if (!skipCache) {
        final cached = LocalAppStorage.getCache(cacheKey);
        if (cached != null) {
          return (cached as List)
              .map<TaskModel>(
                (e) => TaskModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
        }
      }

      final response = await _client
          .from('task_assignments')
          .select('''
          status,
          tasks!inner(
            id, title, type, description, status, date,
            time_start, time_end, duration_hours, points,
            location_name, location_address, location_lat, location_lng,
            supervisor_name, supervisor_phone, notes, created_by,
            users!tasks_created_by_fkey(id, name)
          )
        ''')
          .eq('user_id', userId)
          .eq('tasks.date', today)
          .not('status', 'in', '("completed","missed")');

      final tasks = response.map<TaskModel>((row) {
        final task = row['tasks'] as Map<String, dynamic>;
        final adminUser = task['users'] as Map<String, dynamic>?;
        final adminName = adminUser?['name'] as String? ?? '';

        final assignmentStatus = resolveAssignmentStatus(
          row['status'] as String? ?? 'assigned',
          task['date'] as String?,
          task['time_end'] as String?,
        );
        final resolvedTaskStatus = resolveCampaignStatus(
          task['status'] as String? ?? 'upcoming',
          task['date'] as String?,
          task['time_end'] as String?,
        );
        return TaskModel.fromJson({
          ...task,
          'time_start': (task['time_start'] as String?) ?? '00:00',
          'time_end': (task['time_end'] as String?) ?? '23:59',
          'location_name': (task['location_name'] as String?) ?? '',
          'location_address': (task['location_address'] as String?) ?? '',
          'supervisor_name': adminName.isNotEmpty
              ? adminName
              : ((task['supervisor_name'] as String?) ?? ''),
          'supervisor_phone': (task['supervisor_phone'] as String?) ?? '',
          'status': resolvedTaskStatus,
          'assignment_status': assignmentStatus,
        });
      }).toList();

      await LocalAppStorage.setCache(
        cacheKey,
        tasks.map((t) => t.toJson()).toList(),
        ttl: const Duration(seconds: 30),
      );
      return tasks;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<List<TaskModel>> getCompletedTasks(
    String userId, {
    bool skipCache = false,
  }) async {
    try {
      final cacheKey = 'completed_tasks_$userId';
      if (!skipCache) {
        final cached = LocalAppStorage.getCache(cacheKey);
        if (cached != null) {
          return (cached as List)
              .map<TaskModel>(
                (e) => TaskModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
        }
      }

      final response = await _client
          .from('task_assignments')
          // History only renders cards (details are fetched by id), so the
          // long text / coordinate columns are skipped.
          .select('''
            status,
            tasks!inner(
              id, title, type, status, date,
              time_start, time_end, duration_hours, points,
              location_name, supervisor_name,
              users!tasks_created_by_fkey(name)
            )
          ''')
          .eq('user_id', userId)
          .inFilter('status', ['completed', 'missed'])
          .order('assigned_at', ascending: false);

      final tasks = response.map<TaskModel>((row) {
        final task = row['tasks'] as Map<String, dynamic>;
        final adminUser = task['users'] as Map<String, dynamic>?;
        final adminName = adminUser?['name'] as String? ?? '';

        final resolvedTaskStatus = resolveCampaignStatus(
          task['status'] as String? ?? 'upcoming',
          task['date'] as String?,
          task['time_end'] as String?,
        );
        return TaskModel.fromJson({
          ...task,
          'time_start': (task['time_start'] as String?) ?? '00:00',
          'time_end': (task['time_end'] as String?) ?? '23:59',
          'location_name': (task['location_name'] as String?) ?? '',
          'location_address': (task['location_address'] as String?) ?? '',
          'supervisor_name': adminName.isNotEmpty
              ? adminName
              : ((task['supervisor_name'] as String?) ?? ''),
          'supervisor_phone': (task['supervisor_phone'] as String?) ?? '',
          'status': resolvedTaskStatus,
          'assignment_status': row['status'] as String? ?? 'completed',
        });
      }).toList();

      await LocalAppStorage.setCache(
        cacheKey,
        tasks.map((t) => t.toJson()).toList(),
        ttl: const Duration(minutes: 1),
      );
      return tasks;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  /// Completed count + earned points. `todayCount` is left at 0: the caller
  /// already has today's list and uses its length (it was a duplicate query).
  @override
  Future<TasksStatsModel> getTasksStats(
    String userId, {
    bool skipCache = false,
  }) async {
    try {
      final cacheKey = 'tasks_stats_$userId';
      if (!skipCache) {
        final cached = LocalAppStorage.getCache(cacheKey);
        if (cached != null) {
          final m = Map<String, dynamic>.from(cached as Map);
          return TasksStatsModel(
            completedCount: m['completed_count'] as int,
            earnedPoints: m['earned_points'] as int,
          );
        }
      }

      final results = await Future.wait<Object>([
        _client
            .from('task_assignments')
            .select('id')
            .eq('user_id', userId)
            .eq('status', 'completed')
            .count(CountOption.exact),
        _client.from('users').select('total_points').eq('id', userId).single(),
      ]);
      final completedCount = (results[0] as PostgrestResponse).count;
      final userRow = results[1] as Map<String, dynamic>;
      final earnedPoints = (userRow['total_points'] as num?)?.toInt() ?? 0;

      await LocalAppStorage.setCache(cacheKey, {
        'completed_count': completedCount,
        'earned_points': earnedPoints,
      }, ttl: const Duration(minutes: 1));

      return TasksStatsModel(
        completedCount: completedCount,
        earnedPoints: earnedPoints,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
