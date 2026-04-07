import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart'
    show AdminHomeDataEntity, MonthlyTaskCount;
import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';
import 'package:t3afy/admin/home/data/datasources/admin_home_remote_datasource.dart';

class AdminHomeRemoteDatasourceImpl implements AdminHomeRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<AdminHomeDataEntity> getDashboardData(String adminId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final userRow = await _client
          .from('users')
          .select('name, avatar_url')
          .eq('id', adminId)
          .maybeSingle();

      final adminName = (userRow?['name'] as String?) ?? 'مشرف';
      final adminAvatar = userRow?['avatar_url'] as String?;

      final twoMinutesAgo = DateTime.now()
          .toUtc()
          .subtract(const Duration(minutes: 2))
          .toIso8601String();
      final activeCountRes = await _client
          .from('users')
          .select('id')
          .eq('is_online', true)
          .gt('last_seen_at', twoMinutesAgo)
          .inFilter('role', ['volunteer', 'user']);
      final activeTodayCount = (activeCountRes as List).length;

      final volunteersRes = await _client.from('users').select('id').inFilter(
        'role',
        ['volunteer', 'user'],
      );
      final totalVolunteers = (volunteersRes as List).length;

      final completedRes = await _client.from('tasks').select('id').inFilter(
        'status',
        ['completed', 'done'],
      );
      final completedCampaigns = (completedRes as List).length;

      final hoursRes = await _client
          .from('tasks')
          .select('duration_hours, task_assignments!inner(status)')
          .eq('task_assignments.status', 'completed');
      double totalHours = 0;
      for (final row in hoursRes as List) {
        final h = row['duration_hours'] as num?;
        if (h != null) totalHours += h.toDouble();
      }

      final now = DateTime.now();
      final firstDayOfMonth = DateTime(
        now.year,
        now.month,
        1,
      ).toIso8601String().split('T')[0];
      final volunteersThisMonthRes = await _client
          .from('users')
          .select('id')
          .inFilter('role', ['volunteer', 'user'])
          .gte('joined_at', firstDayOfMonth);
      final volunteersThisMonth = (volunteersThisMonthRes as List).length;

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
      final activeYesterdayRes = await _client
          .from('users')
          .select('id')
          .inFilter('role', ['volunteer', 'user'])
          .gte('last_seen_at', yesterdayStart)
          .lt('last_seen_at', yesterdayEnd);
      final activeYesterdayCount = (activeYesterdayRes as List).length;
      final activeDiffFromYesterday = activeTodayCount - activeYesterdayCount;

      final firstDayOfLastMonth = DateTime(
        now.year,
        now.month - 1,
        1,
      ).toIso8601String().split('T')[0];
      final hoursThisMonthRes = await _client
          .from('tasks')
          .select('duration_hours, task_assignments!inner(status)')
          .eq('task_assignments.status', 'completed')
          .gte('date', firstDayOfMonth);
      double hoursThisMonth = 0;
      for (final row in hoursThisMonthRes as List) {
        final h = row['duration_hours'] as num?;
        if (h != null) hoursThisMonth += h.toDouble();
      }
      final hoursLastMonthRes = await _client
          .from('tasks')
          .select('duration_hours, task_assignments!inner(status)')
          .eq('task_assignments.status', 'completed')
          .gte('date', firstDayOfLastMonth)
          .lt('date', firstDayOfMonth);
      double hoursLastMonth = 0;
      for (final row in hoursLastMonthRes as List) {
        final h = row['duration_hours'] as num?;
        if (h != null) hoursLastMonth += h.toDouble();
      }
      final hoursPercentChange = hoursLastMonth == 0
          ? 0
          : ((hoursThisMonth - hoursLastMonth) / hoursLastMonth * 100).round();

      final todayTasksRaw = await _client
          .from('tasks')
          .select()
          .eq('date', today)
          .order('time_start');

      final twelveMonthsAgo = DateTime.now()
          .subtract(const Duration(days: 365))
          .toIso8601String()
          .split('T')[0];
      final monthlyRaw = await _client
          .from('tasks')
          .select('date')
          .inFilter('status', ['completed', 'done'])
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
      final monthlyCompletedTasks = monthMap.entries.map((e) {
        final parts = e.key.split('-');
        return MonthlyTaskCount(
          month: DateTime(int.parse(parts[0]), int.parse(parts[1])),
          count: e.value,
        );
      }).toList()..sort((a, b) => a.month.compareTo(b.month));

      final todayCampaigns = <TodayCampaignEntity>[];
      for (final t in todayTasksRaw as List) {
        final taskMap = t as Map<String, dynamic>;
        final taskId = taskMap['id'] as String;
        final assignRes = await _client
            .from('task_assignments')
            .select('id')
            .eq('task_id', taskId);
        final volunteerCount = (assignRes as List).length;

        todayCampaigns.add(
          TodayCampaignEntity(
            id: taskId,
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
            volunteerCount: volunteerCount,
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
