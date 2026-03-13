import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/volunteer/performance/data/models/performance_models.dart';
import 'package:t3afy/volunteer/performance/data/sources/performance_remote_data_source.dart';

class PerformanceImplRemoteDataSource implements PerformanceRemoteDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<(PerformanceStatsModel, double)> getPerformanceStats(
    String userId,
  ) async {
    try {
      // Fetch user stats (without total_points — column may not exist)
      final response = await _client
          .from('users')
          .select(
            'name, avatar_url, rating, level, level_title, total_hours, places_visited',
          )
          .eq('id', userId)
          .single();

      // Compute commitment % and total points from assignments
      final assignments = await _client
          .from('task_assignments')
          .select('status, tasks(points)')
          .eq('user_id', userId);

      double commitmentPct = 0;
      int totalPoints = 0;
      if ((assignments as List).isNotEmpty) {
        final completed =
            assignments.where((a) => a['status'] == 'completed').toList();
        commitmentPct = (completed.length * 100.0) / assignments.length;

        for (final a in completed) {
          final task = a['tasks'];
          if (task != null) {
            totalPoints += (task['points'] as num?)?.toInt() ?? 0;
          }
        }
      }

      // Inject totalPoints into the response map
      response['total_points'] = totalPoints;
      final stats = PerformanceStatsModel.fromJson(response);

      return (stats, commitmentPct);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<MonthlyHoursModel>> getMonthlyHours(String userId) async {
    try {
      // Get completed assignments for this user with task data
      final response = await _client
          .from('task_assignments')
          .select('task_id, tasks(date, duration_hours)')
          .eq('user_id', userId)
          .eq('status', 'completed');

      // Group by month manually
      final Map<String, double> monthlyMap = {};

      for (final row in (response as List)) {
        final task = row['tasks'];
        if (task == null) continue;

        final dateStr = task['date'] as String?;
        final duration = (task['duration_hours'] as num?)?.toDouble() ?? 0;

        if (dateStr == null) continue;

        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;

        final key = '${date.year}-${date.month}';
        monthlyMap[key] = (monthlyMap[key] ?? 0) + duration;
      }

      // Convert to models, sorted by date
      final entries = monthlyMap.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Return last 3 months
      final last3 = entries.length > 3
          ? entries.sublist(entries.length - 3)
          : entries;

      return last3.map((e) {
        final parts = e.key.split('-');
        return MonthlyHoursModel(
          year: int.parse(parts[0]),
          month: int.parse(parts[1]),
          hours: e.value,
        );
      }).toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    try {
      // Get all volunteers
      final users = await _client
          .from('users')
          .select('id, name, avatar_url, total_hours')
          .eq('role', 'volunteer');

      // For each volunteer, compute points from completed assignments
      final List<LeaderboardEntryModel> entries = [];

      for (final user in (users as List)) {
        final userId = user['id'] as String;

        final assignments = await _client
            .from('task_assignments')
            .select('tasks(points)')
            .eq('user_id', userId)
            .eq('status', 'completed');

        int pts = 0;
        for (final a in (assignments as List)) {
          final task = a['tasks'];
          if (task != null) {
            pts += (task['points'] as num?)?.toInt() ?? 0;
          }
        }

        entries.add(LeaderboardEntryModel(
          id: userId,
          name: user['name'] as String,
          avatarUrl: (user['avatar_url'] as String?) ?? '',
          totalHours: (user['total_hours'] as num?)?.toInt() ?? 0,
          pts: pts,
        ));
      }

      // Sort by points descending
      entries.sort((a, b) => b.pts.compareTo(a.pts));

      // If fewer than 3 entries, pad with dummy data
      if (entries.length < 3) {
        final dummyNames = ['سارة احمد', 'أحمد محمد', 'محمد علي'];
        final dummyHours = [160, 145, 130];
        final dummyPts = [480, 420, 390];
        final existingIds = entries.map((e) => e.id).toSet();

        for (int i = 0; entries.length < 3 && i < 3; i++) {
          final dummyId = 'dummy_$i';
          if (!existingIds.contains(dummyId)) {
            entries.add(LeaderboardEntryModel(
              id: dummyId,
              name: dummyNames[i],
              avatarUrl: '',
              totalHours: dummyHours[i],
              pts: dummyPts[i],
            ));
          }
        }

        entries.sort((a, b) => b.pts.compareTo(a.pts));
      }

      // Return top 10
      return entries.take(10).toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}
