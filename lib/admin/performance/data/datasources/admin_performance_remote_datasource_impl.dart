import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart'
    show MonthlyTaskCount;
import 'package:t3afy/admin/performance/data/datasources/admin_performance_remote_datasource.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/error_handler.dart';

class AdminPerformanceRemoteDatasourceImpl
    implements AdminPerformanceRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<AdminPerformanceEntity> getPerformanceData() async {
    try {
      // -- Volunteer summary --
      final volunteersRaw = await _client
          .from('users')
          .select('total_hours, rating')
          .inFilter('role', ['volunteer', 'user']);
      final volunteers = volunteersRaw as List;
      final totalVolunteers = volunteers.length;
      int totalHours = 0;
      double ratingSum = 0;
      int ratingCount = 0;
      for (final v in volunteers) {
        final h = v['total_hours'] as num?;
        if (h != null) totalHours += h.toInt();
        final r = v['rating'] as num?;
        if (r != null && r > 0) {
          ratingSum += r.toDouble();
          ratingCount++;
        }
      }
      final avgRating = ratingCount > 0 ? ratingSum / ratingCount : 0.0;

      // -- Monthly completed tasks (last 12 months) --
      final twelveMonthsAgo = DateTime.now()
          .subtract(const Duration(days: 365))
          .toIso8601String()
          .split('T')[0];
      final monthlyRaw = await _client
          .from('tasks')
          .select('date')
          .eq('status', 'done')
          .gte('date', twelveMonthsAgo);
      final monthMap = <String, int>{};
      for (final row in monthlyRaw as List) {
        final dateStr = row['date'] as String?;
        if (dateStr == null) continue;
        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;
        final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        monthMap[key] = (monthMap[key] ?? 0) + 1;
      }
      final monthlyCompletedTasks = monthMap.entries
          .map((e) {
            final parts = e.key.split('-');
            return MonthlyTaskCount(
              month: DateTime(int.parse(parts[0]), int.parse(parts[1])),
              count: e.value,
            );
          })
          .toList()
        ..sort((a, b) => a.month.compareTo(b.month));

      // -- Top regions --
      final regionsRaw = await _client
          .from('users')
          .select('region')
          .inFilter('role', ['volunteer', 'user']);
      final regionMap = <String, int>{};
      for (final row in regionsRaw as List) {
        final region = row['region'] as String?;
        if (region == null || region.isEmpty) continue;
        regionMap[region] = (regionMap[region] ?? 0) + 1;
      }
      final topRegions = (regionMap.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)))
          .take(5)
          .map((e) =>
              RegionStatEntity(region: e.key, volunteerCount: e.value))
          .toList();

      // -- Campaign completion --
      final tasksRaw =
          await _client.from('tasks').select('status');
      final allTasks = tasksRaw as List;
      final totalCampaigns = allTasks.length;
      final completedCampaigns =
          allTasks.where((t) => t['status'] == 'done').length;
      final campaignCompletionPercent = totalCampaigns > 0
          ? (completedCampaigns / totalCampaigns * 100)
          : 0.0;

      // -- Completion percent change (this month vs last month) --
      final now = DateTime.now();
      final firstDayOfMonth =
          DateTime(now.year, now.month, 1).toIso8601String().split('T')[0];
      final firstDayOfLastMonth =
          DateTime(now.year, now.month - 1, 1).toIso8601String().split('T')[0];
      final thisMonthDone = await _client
          .from('tasks')
          .select('id')
          .eq('status', 'done')
          .gte('date', firstDayOfMonth);
      final lastMonthDone = await _client
          .from('tasks')
          .select('id')
          .eq('status', 'done')
          .gte('date', firstDayOfLastMonth)
          .lt('date', firstDayOfMonth);
      final thisCount = (thisMonthDone as List).length;
      final lastCount = (lastMonthDone as List).length;
      final completionPercentChange = lastCount == 0
          ? (thisCount > 0 ? 100.0 : 0.0)
          : ((thisCount - lastCount) / lastCount * 100);

      return AdminPerformanceEntity(
        totalVolunteers: totalVolunteers,
        totalHours: totalHours,
        avgRating: avgRating,
        monthlyCompletedTasks: monthlyCompletedTasks,
        topRegions: topRegions,
        totalCampaigns: totalCampaigns,
        completedCampaigns: completedCampaigns,
        campaignCompletionPercent: campaignCompletionPercent,
        completionPercentChange: completionPercentChange,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
