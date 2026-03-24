import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/performance/data/datasources/admin_performance_remote_datasource.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';

class AdminPerformanceRemoteDatasourceImpl
    implements AdminPerformanceRemoteDatasource {
  final _client = Supabase.instance.client;

  static const _arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  static const _arabicDays = [
    'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد',
  ];

  @override
  Future<AdminPerformanceEntity> getPerformanceData(
      DateTime startDate, String period) async {
    try {
      final cacheKey = 'admin_performance_$period';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return _fromJson(cached as Map<String, dynamic>);
      }

      final startStr = startDate.toIso8601String().split('T')[0];
      final now = DateTime.now();

      final results = await Future.wait([
        // 0: volunteers joined in period
        _client
            .from('users')
            .select('joined_at')
            .inFilter('role', ['volunteer', 'user'])
            .gte('joined_at', startStr),

        // 1: completed task assignments + task date for hours
        _client
            .from('task_assignments')
            .select('tasks!inner(date, duration_hours)')
            .eq('status', 'completed')
            .gte('tasks.date', startStr),

        // 2: assessments for avg rating in period
        _client
            .from('assessments')
            .select('rating')
            .gte('created_at', startStr),

        // 3: completed task_assignments for chart (date from tasks)
        _client
            .from('task_assignments')
            .select('tasks!inner(date)')
            .eq('status', 'completed')
            .gte('tasks.date', startStr),

        // 4: all volunteers by region in period
        _client
            .from('users')
            .select('region')
            .inFilter('role', ['volunteer', 'user'])
            .gte('joined_at', startStr),

        // 5: all tasks in period for completion rate
        _client
            .from('tasks')
            .select('status')
            .gte('date', startStr),
      ]);

      // --- Stats ---
      final totalVolunteers = (results[0] as List).length;

      int totalHours = 0;
      for (final row in results[1] as List) {
        final task = row['tasks'] as Map<String, dynamic>?;
        final h = task?['duration_hours'] as num?;
        if (h != null) totalHours += h.toInt();
      }

      final assessmentRows = results[2] as List;
      double ratingSum = 0;
      int ratingCount = 0;
      for (final row in assessmentRows) {
        final r = row['rating'] as num?;
        if (r != null && r > 0) {
          ratingSum += r.toDouble();
          ratingCount++;
        }
      }
      final avgRating = ratingCount > 0 ? ratingSum / ratingCount : 0.0;

      // --- Chart bars ---
      final chartRows = results[3] as List;
      final chartBars = _buildChartBars(chartRows, startDate, now, period);

      // --- Regions ---
      final regionMap = <String, int>{};
      for (final row in results[4] as List) {
        final region = row['region'] as String?;
        if (region == null || region.isEmpty) continue;
        regionMap[region] = (regionMap[region] ?? 0) + 1;
      }
      final topRegions = (regionMap.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)))
          .where((e) => e.value > 0)
          .take(5)
          .map((e) => RegionStatEntity(region: e.key, volunteerCount: e.value))
          .toList();

      // --- Campaign completion rate ---
      final allTasks = results[5] as List;
      final totalCampaigns = allTasks.length;
      final completedCampaigns =
          allTasks.where((t) => t['status'] == 'done').length;
      final campaignCompletionPercent = totalCampaigns > 0
          ? (completedCampaigns / totalCampaigns * 100)
          : 0.0;

      // --- Completion percent change vs previous equivalent period ---
      final periodDays = _periodDays(period);
      final prevStart =
          startDate.subtract(Duration(days: periodDays)).toIso8601String().split('T')[0];
      final prevEnd = startStr;

      final prevDoneRaw = await _client
          .from('tasks')
          .select('id')
          .eq('status', 'done')
          .gte('date', prevStart)
          .lt('date', prevEnd);
      final prevCount = (prevDoneRaw as List).length;
      final completionPercentChange = prevCount == 0
          ? (completedCampaigns > 0 ? 100.0 : 0.0)
          : ((completedCampaigns - prevCount) / prevCount * 100);

      final entity = AdminPerformanceEntity(
        totalVolunteers: totalVolunteers,
        totalHours: totalHours,
        avgRating: avgRating,
        chartBars: chartBars,
        topRegions: topRegions,
        totalCampaigns: totalCampaigns,
        completedCampaigns: completedCampaigns,
        campaignCompletionPercent: campaignCompletionPercent,
        completionPercentChange: completionPercentChange,
      );

      await LocalAppStorage.setCache(
        cacheKey,
        _toJson(entity),
        ttl: const Duration(minutes: 5),
      );

      return entity;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  int _periodDays(String period) {
    switch (period) {
      case 'week':
        return 7;
      case 'months':
        return 30;
      default:
        return 365;
    }
  }

  List<PerformanceBarEntry> _buildChartBars(
    List rows,
    DateTime startDate,
    DateTime now,
    String period,
  ) {
    switch (period) {
      case 'week':
        return _buildWeekBars(rows, startDate, now);
      case 'months':
        return _buildMonthBars(rows, startDate);
      default:
        return _buildYearBars(rows);
    }
  }

  /// 7 bars — one per day
  List<PerformanceBarEntry> _buildWeekBars(
      List rows, DateTime startDate, DateTime now) {
    final countByDate = <String, int>{};
    for (final row in rows) {
      final task = row['tasks'] as Map<String, dynamic>?;
      final dateStr = task?['date'] as String?;
      if (dateStr == null) continue;
      countByDate[dateStr] = (countByDate[dateStr] ?? 0) + 1;
    }

    final bars = <PerformanceBarEntry>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      // weekday: 1=Mon … 7=Sun
      final label = _arabicDays[day.weekday - 1];
      bars.add(PerformanceBarEntry(label: label, count: countByDate[key] ?? 0));
    }
    return bars;
  }

  /// 4 bars — one per week within last 30 days
  List<PerformanceBarEntry> _buildMonthBars(List rows, DateTime startDate) {
    final countByWeek = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};
    for (final row in rows) {
      final task = row['tasks'] as Map<String, dynamic>?;
      final dateStr = task?['date'] as String?;
      if (dateStr == null) continue;
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;
      final dayOffset = date.difference(startDate).inDays;
      final weekIndex = (dayOffset ~/ 7).clamp(0, 3);
      countByWeek[weekIndex] = (countByWeek[weekIndex] ?? 0) + 1;
    }

    return List.generate(4, (i) {
      return PerformanceBarEntry(
        label: 'الأسبوع ${i + 1}',
        count: countByWeek[i] ?? 0,
      );
    });
  }

  /// 12 bars — one per month for last 12 months
  List<PerformanceBarEntry> _buildYearBars(List rows) {
    final now = DateTime.now();
    final countByMonth = <String, int>{};
    for (final row in rows) {
      final task = row['tasks'] as Map<String, dynamic>?;
      final dateStr = task?['date'] as String?;
      if (dateStr == null) continue;
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      countByMonth[key] = (countByMonth[key] ?? 0) + 1;
    }

    final bars = <PerformanceBarEntry>[];
    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final key =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      bars.add(PerformanceBarEntry(
        label: _arabicMonths[month.month - 1],
        count: countByMonth[key] ?? 0,
      ));
    }
    return bars;
  }

  // --- Serialization for cache ---

  Map<String, dynamic> _toJson(AdminPerformanceEntity e) => {
        'totalVolunteers': e.totalVolunteers,
        'totalHours': e.totalHours,
        'avgRating': e.avgRating,
        'chartBars': e.chartBars
            .map((b) => {'label': b.label, 'count': b.count})
            .toList(),
        'topRegions': e.topRegions
            .map((r) =>
                {'region': r.region, 'volunteerCount': r.volunteerCount})
            .toList(),
        'totalCampaigns': e.totalCampaigns,
        'completedCampaigns': e.completedCampaigns,
        'campaignCompletionPercent': e.campaignCompletionPercent,
        'completionPercentChange': e.completionPercentChange,
      };

  AdminPerformanceEntity _fromJson(Map<String, dynamic> m) =>
      AdminPerformanceEntity(
        totalVolunteers: (m['totalVolunteers'] as num).toInt(),
        totalHours: (m['totalHours'] as num).toInt(),
        avgRating: (m['avgRating'] as num).toDouble(),
        chartBars: (m['chartBars'] as List)
            .map((b) => PerformanceBarEntry(
                  label: b['label'] as String,
                  count: (b['count'] as num).toInt(),
                ))
            .toList(),
        topRegions: (m['topRegions'] as List)
            .map((r) => RegionStatEntity(
                  region: r['region'] as String,
                  volunteerCount: (r['volunteerCount'] as num).toInt(),
                ))
            .toList(),
        totalCampaigns: (m['totalCampaigns'] as num).toInt(),
        completedCampaigns: (m['completedCampaigns'] as num).toInt(),
        campaignCompletionPercent:
            (m['campaignCompletionPercent'] as num).toDouble(),
        completionPercentChange:
            (m['completionPercentChange'] as num).toDouble(),
      );
}
