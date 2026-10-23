import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart'
    show AdminHomeDataEntity, MonthlyTaskCount;
import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';
import 'package:t3afy/admin/home/data/datasources/admin_home_remote_datasource.dart';

class AdminHomeRemoteDatasourceImpl implements AdminHomeRemoteDatasource {
  final _client = Supabase.instance.client;

  static const _volunteerRoles = ['volunteer', 'user'];

  static List<Map<String, dynamic>> _rows(Object? v) =>
      (v as List).cast<Map<String, dynamic>>();

  /// Sum of `duration_hours` over tasks that have a completed assignment.
  static double _sumHours(List<Map<String, dynamic>> rows) {
    double total = 0;
    for (final row in rows) {
      final h = row['duration_hours'] as num?;
      if (h != null) total += h.toDouble();
    }
    return total;
  }

  @override
  Future<AdminHomeDataEntity> getDashboardData(String adminId) async {
    try {
      final now = DateTime.now();
      final today = now.toIso8601String().split('T')[0];
      final twoMinutesAgo = now
          .toUtc()
          .subtract(const Duration(minutes: 2))
          .toIso8601String();
      final firstDayOfMonth = DateTime(
        now.year,
        now.month,
        1,
      ).toIso8601String().split('T')[0];
      final firstDayOfLastMonth = DateTime(
        now.year,
        now.month - 1,
        1,
      ).toIso8601String().split('T')[0];
      final yesterdayStart = DateTime(
        now.year,
        now.month,
        now.day - 1,
      ).toUtc().toIso8601String();
      final yesterdayEnd = DateTime(
        now.year,
        now.month,
        now.day,
      ).toUtc().toIso8601String();
      final twelveMonthsAgo = now
          .subtract(const Duration(days: 365))
          .toIso8601String()
          .split('T')[0];

      // All queries are independent → one round of parallel requests.
      // Counts use HEAD + exact count instead of downloading rows.
      final results = await Future.wait<Object?>([
        _client
            .from('users')
            .select('name, avatar_url')
            .eq('id', adminId)
            .maybeSingle(),
        _client
            .from('users')
            .count(CountOption.exact)
            .eq('is_online', true)
            .gt('last_seen_at', twoMinutesAgo)
            .inFilter('role', _volunteerRoles),
        _client
            .from('users')
            .count(CountOption.exact)
            .inFilter('role', _volunteerRoles),
        _client
            .from('tasks')
            .count(CountOption.exact)
            .inFilter('status', ['completed', 'done']),
        _client
            .from('tasks')
            .select('duration_hours, task_assignments!inner(status)')
            .eq('task_assignments.status', 'completed'),
        _client
            .from('users')
            .count(CountOption.exact)
            .inFilter('role', _volunteerRoles)
            .gte('joined_at', firstDayOfMonth),
        _client
            .from('users')
            .count(CountOption.exact)
            .inFilter('role', _volunteerRoles)
            .gte('last_seen_at', yesterdayStart)
            .lt('last_seen_at', yesterdayEnd),
        _client
            .from('tasks')
            .select('duration_hours, task_assignments!inner(status)')
            .eq('task_assignments.status', 'completed')
            .gte('date', firstDayOfMonth),
        _client
            .from('tasks')
            .select('duration_hours, task_assignments!inner(status)')
            .eq('task_assignments.status', 'completed')
            .gte('date', firstDayOfLastMonth)
            .lt('date', firstDayOfMonth),
        // Assignments embedded → no per-task query (was N+1).
        _client
            .from('tasks')
            .select(
              'id, title, type, status, date, time_start, time_end, '
              'location_name, supervisor_name, target_beneficiaries, '
              'reached_beneficiaries, task_assignments(id, status)',
            )
            .eq('date', today)
            .order('time_start'),
        _client
            .from('tasks')
            .select('date')
            .inFilter('status', ['completed', 'done'])
            .gte('date', twelveMonthsAgo),
      ]);

      final userRow = results[0] as Map<String, dynamic>?;
      final adminName = (userRow?['name'] as String?) ?? 'مشرف';
      final adminAvatar = userRow?['avatar_url'] as String?;

      final activeTodayCount = results[1] as int;
      final totalVolunteers = results[2] as int;
      final completedCampaigns = results[3] as int;
      final totalHours = _sumHours(_rows(results[4]));
      final volunteersThisMonth = results[5] as int;
      final activeYesterdayCount = results[6] as int;
      final activeDiffFromYesterday = activeTodayCount - activeYesterdayCount;

      final hoursThisMonth = _sumHours(
        _rows(results[7]),
      );
      final hoursLastMonth = _sumHours(
        _rows(results[8]),
      );
      final hoursPercentChange = hoursLastMonth == 0
          ? 0
          : ((hoursThisMonth - hoursLastMonth) / hoursLastMonth * 100).round();

      final monthMap = <String, int>{};
      for (final row in _rows(results[10])) {
        final dateStr = row['date'] as String?;
        if (dateStr == null) continue;
        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;
        final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        monthMap[key] = (monthMap[key] ?? 0) + 1;
      }
      final monthlyCompletedTasks = monthMap.entries.map((e) {
        final parts = e.key.split('-');
        return MonthlyTaskCount(
          month: DateTime(int.parse(parts[0]), int.parse(parts[1])),
          count: e.value,
        );
      }).toList()..sort((a, b) => a.month.compareTo(b.month));

      final todayCampaigns = <TodayCampaignEntity>[];
      for (final taskMap in _rows(results[9])) {
        final assignments = (taskMap['task_assignments'] as List?) ?? const [];
        final completedCount = assignments
            .where((a) => (a as Map)['status'] == 'completed')
            .length;

        todayCampaigns.add(
          TodayCampaignEntity(
            id: taskMap['id'] as String,
            title: taskMap['title'] as String? ?? '',
            type: taskMap['type'] as String? ?? '',
            status: resolveCampaignStatus(
              taskMap['status'] as String? ?? 'upcoming',
              taskMap['date'] as String?,
              taskMap['time_end'] as String?,
            ),
            timeStart: taskMap['time_start'] as String? ?? '',
            timeEnd: taskMap['time_end'] as String? ?? '',
            locationName: taskMap['location_name'] as String?,
            supervisorName: taskMap['supervisor_name'] as String?,
            volunteerCount: assignments.length,
            completedCount: completedCount,
            targetBeneficiaries: taskMap['target_beneficiaries'] as int?,
            reachedBeneficiaries: taskMap['reached_beneficiaries'] as int?,
          ),
        );
      }

      return AdminHomeDataEntity(
        adminName: adminName,
        adminAvatar: adminAvatar,
        activeTodayCount: activeTodayCount,
        totalVolunteers: totalVolunteers,
        completedCampaigns: completedCampaigns,
        totalHours: totalHours,
        todayCampaigns: todayCampaigns,
        monthlyCompletedTasks: monthlyCompletedTasks,
        volunteersThisMonth: volunteersThisMonth,
        activeDiffFromYesterday: activeDiffFromYesterday,
        hoursPercentChange: hoursPercentChange,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> sendAnnouncement({
    required String title,
    required String body,
    required String adminId,
  }) async {
    try {
      final volunteersRes = await _client.from('users').select('id').inFilter(
        'role',
        ['volunteer', 'user'],
      );

      final volunteersIds = (volunteersRes as List)
          .map((e) => e['id'] as String)
          .toList();

      final now = DateTime.now().toUtc().toIso8601String();
      final announcements = volunteersIds
          .map(
            (volunteerId) => {
              'admin_id': adminId,
              'volunteer_id': volunteerId,
              'task_id': null,
              'title': title,
              'body': body,
              'is_read': false,
              'created_at': now,
            },
          )
          .toList();

      await _client.from('admin_notes').insert(announcements);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
