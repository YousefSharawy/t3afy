import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/performance/data/models/performance_models.dart';
import 'package:t3afy/volunteer/performance/data/sources/performance_remote_data_source.dart';

class PerformanceImplRemoteDataSource implements PerformanceRemoteDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<(PerformanceStatsModel, double)> getPerformanceStats(
    String userId,
  ) async {
    try {
      final cacheKey = 'perf_stats_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        final m = Map<String, dynamic>.from(cached as Map);
        final stats = PerformanceStatsModel.fromJson(
          Map<String, dynamic>.from(m['stats'] as Map),
        );
        final commitment = (m['commitment'] as num).toDouble();
        return (stats, commitment);
      }

      final response = await _client
          .from('users')
          .select(
            'name, avatar_url, rating, level, level_title, total_hours, places_visited, total_points',
          )
          .eq('id', userId)
          .single();

      final assignments = await _client
          .from('task_assignments')
          .select('status')
          .eq('user_id', userId);

      double commitmentPct = 0;
      if ((assignments as List).isNotEmpty) {
        final completed = assignments
            .where((a) => a['status'] == 'completed')
            .toList();
        commitmentPct = (completed.length * 100.0) / assignments.length;
      }

      final stats = PerformanceStatsModel.fromJson(response);

      await LocalAppStorage.setCache(cacheKey, {
        'stats': stats.toJson(),
        'commitment': commitmentPct,
      }, ttl: const Duration(minutes: 1));

      return (stats, commitmentPct);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<MonthlyHoursModel>> getMonthlyHours(String userId) async {
    try {
      final cacheKey = 'monthly_hours_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map<MonthlyHoursModel>(
              (e) => MonthlyHoursModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      }

      final response = await _client
          .from('task_assignments')
          .select(
            'verified_hours, tasks(date, duration_hours, time_start, time_end)',
          )
          .eq('user_id', userId)
          .eq('status', 'completed');

      final Map<String, double> monthlyMap = {};
      for (final row in (response as List)) {
        final task = row['tasks'];
        if (task == null) continue;
        final dateStr = task['date'] as String?;
        if (dateStr == null) continue;
        final verifiedHours =
            (row['verified_hours'] as num?)?.toDouble();
        final durationHours =
            (task['duration_hours'] as num?)?.toDouble();
        final duration = verifiedHours ??
            (durationHours != null && durationHours > 0
                ? durationHours
                : _hoursFromTime(
                    task['time_start'] as String?,
                    task['time_end'] as String?,
                  ));
        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;
        final key = '${date.year}-${date.month}';
        monthlyMap[key] = (monthlyMap[key] ?? 0) + duration;
      }

      final entries = monthlyMap.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final last3 = entries.length > 3
          ? entries.sublist(entries.length - 3)
          : entries;

      final result = last3.map((e) {
        final parts = e.key.split('-');
        return MonthlyHoursModel(
          year: int.parse(parts[0]),
          month: int.parse(parts[1]),
          hours: e.value,
        );
      }).toList();

      await LocalAppStorage.setCache(
        cacheKey,
        result.map((m) => m.toJson()).toList(),
        ttl: const Duration(minutes: 1),
      );
      return result;
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  double _hoursFromTime(String? start, String? end) {
    if (start == null || end == null) return 0;
    final s = DateTime.tryParse(start);
    final e = DateTime.tryParse(end);
    if (s == null || e == null) return 0;
    final diff = e.difference(s).inMinutes;
    return diff > 0 ? diff / 60.0 : 0;
  }

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    try {
      const cacheKey = 'leaderboard_v2';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map<LeaderboardEntryModel>(
              (e) => LeaderboardEntryModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      }

      final users = await _client
          .from('users')
          .select('id, name, avatar_url, total_hours, total_points')
          .eq('role', 'volunteer')
          .order('total_points', ascending: false)
          .limit(3);

      final List<LeaderboardEntryModel> entries = [];
      for (final user in (users as List)) {
        entries.add(
          LeaderboardEntryModel(
            id: user['id'] as String,
            name: user['name'] as String,
            avatarUrl: (user['avatar_url'] as String?) ?? '',
            totalHours: (user['total_hours'] as num?)?.toInt() ?? 0,
            pts: (user['total_points'] as num?)?.toInt() ?? 0,
          ),
        );
      }

      final result = entries;
      await LocalAppStorage.setCache(
        cacheKey,
        result.map((e) => e.toJson()).toList(),
        ttl: const Duration(minutes: 1),
      );
      return result;
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}
