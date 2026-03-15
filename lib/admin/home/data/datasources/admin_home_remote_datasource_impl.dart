import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
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
          .select()
          .eq('is_online', true)
          .gt('last_seen_at', twoMinutesAgo)
          .inFilter('role', ['volunteer', 'user']);
      final activeTodayCount = (activeCountRes as List).length;

      final volunteersRes = await _client.from('users').select().inFilter(
        'role',
        ['volunteer', 'user'],
      );
      final totalVolunteers = (volunteersRes as List).length;

      final completedRes = await _client
          .from('tasks')
          .select('id')
          .eq('status', 'done');
      final completedCampaigns = (completedRes as List).length;

      final hoursRes = await _client
          .from('users')
          .select('total_hours')
          .inFilter('role', ['volunteer', 'user']);
      double totalHours = 0;
      for (final row in hoursRes as List) {
        final hours = row['total_hours'] as num?;
        if (hours != null) {
          totalHours += hours.toDouble();
        }
      }

      final todayTasksRaw = await _client
          .from('tasks')
          .select()
          .eq('date', today)
          .order('time_start');

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
            status: taskMap['status'] as String? ?? 'active',
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
