import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/entities/campaign_detail_entity.dart';
import '../../domain/entities/campaign_member_entity.dart';
import '../../domain/entities/campaign_objective_entity.dart';
import '../../domain/entities/campaign_supply_entity.dart';
import '../../domain/entities/volunteer_entity.dart';
import 'campaigns_remote_datasource.dart';

class CampaignsRemoteDatasourceImpl implements CampaignsRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<List<CampaignEntity>> getCampaigns() async {
    try {
      final tasksRaw = await _client
          .from('tasks')
          .select()
          .order('date', ascending: false);

      final campaigns = <CampaignEntity>[];
      for (final t in tasksRaw as List) {
        final taskMap = t as Map<String, dynamic>;
        final taskId = taskMap['id'] as String;

        final assignRes = await _client
            .from('task_assignments')
            .select('id')
            .eq('task_id', taskId);
        final volunteerCount = (assignRes as List).length;

        campaigns.add(
          CampaignEntity(
            id: taskId,
            title: taskMap['title'] as String? ?? '',
            type: taskMap['type'] as String? ?? '',
            status: taskMap['status'] as String? ?? 'upcoming',
            date: (taskMap['date'] as String?) ?? '',
            timeStart: taskMap['time_start'] as String?,
            timeEnd: taskMap['time_end'] as String?,
            locationName: taskMap['location_name'] as String?,
            locationAddress: taskMap['location_address'] as String?,
            supervisorName: taskMap['supervisor_name'] as String?,
            volunteerCount: volunteerCount,
            targetBeneficiaries: (taskMap['target_beneficiaries'] as int?) ?? 0,
            reachedBeneficiaries: (taskMap['reached_beneficiaries'] as int?) ?? 0,
            points: (taskMap['points'] as int?) ?? 0,
          ),
        );
      }
      return campaigns;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<Map<String, int>> getCampaignStats() async {
    try {
      final unreadRes = await _client
          .from('admin_notes')
          .select('id')
          .eq('is_read', false);
      final unreadCount = (unreadRes as List).length;

      final upcomingRes = await _client
          .from('tasks')
          .select('id')
          .eq('status', 'upcoming');
      final upcomingCount = (upcomingRes as List).length;

      final doneRes = await _client
          .from('tasks')
          .select('id')
          .eq('status', 'done');
      final doneCount = (doneRes as List).length;

      return {
        'notifications': unreadCount,
        'upcoming': upcomingCount,
        'done': doneCount,
      };
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<CampaignDetailEntity> getCampaignDetail(String id) async {
    try {
      final taskRaw = await _client
          .from('tasks')
          .select()
          .eq('id', id)
          .single();

      final taskMap = taskRaw;

      // Objectives
      final objectivesRaw = await _client
          .from('task_objectives')
          .select()
          .eq('task_id', id)
          .order('order_index');
      final objectives = (objectivesRaw as List)
          .map(
            (o) => CampaignObjectiveEntity(
              id: o['id'] as String,
              title: o['title'] as String? ?? '',
              orderIndex: (o['order_index'] as int?) ?? 0,
            ),
          )
          .toList();

      // Supplies
      final suppliesRaw = await _client
          .from('task_supplies')
          .select()
          .eq('task_id', id);
      final supplies = (suppliesRaw as List)
          .map(
            (s) => CampaignSupplyEntity(
              id: s['id'] as String,
              name: s['name'] as String? ?? '',
              quantity: (s['quantity'] as int?) ?? 1,
            ),
          )
          .toList();

      // Members via task_assignments joined with users
     final assignmentsRaw = await _client
    .from('task_assignments')
    .select('user_id, status, users!task_assignments_user_id_fkey(id, name, avatar_url, rating, region, is_online, last_seen_at)')
    .eq('task_id', id);

      final members = <CampaignMemberEntity>[];
      for (final a in assignmentsRaw as List) {
        final u = a['users'] as Map<String, dynamic>?;
        if (u == null) continue;
        final lastSeenStr = u['last_seen_at'] as String?;
        members.add(
          CampaignMemberEntity(
            id: u['id'] as String? ?? a['user_id'] as String,
            name: u['name'] as String? ?? '',
            avatarUrl: u['avatar_url'] as String?,
            rating: ((u['rating'] as num?) ?? 0).toDouble(),
            region: u['region'] as String?,
            isOnline: (u['is_online'] as bool?) ?? false,
            lastSeenAt: lastSeenStr != null ? DateTime.tryParse(lastSeenStr) : null,
          ),
        );
      }

      return CampaignDetailEntity(
        id: taskMap['id'] as String,
        title: taskMap['title'] as String? ?? '',
        type: taskMap['type'] as String? ?? '',
        status: taskMap['status'] as String? ?? 'upcoming',
        date: (taskMap['date'] as String?) ?? '',
        timeStart: taskMap['time_start'] as String?,
        timeEnd: taskMap['time_end'] as String?,
        locationName: taskMap['location_name'] as String?,
        locationAddress: taskMap['location_address'] as String?,
        supervisorName: taskMap['supervisor_name'] as String?,
        supervisorPhone: taskMap['supervisor_phone'] as String?,
        description: taskMap['description'] as String?,
        notes: taskMap['notes'] as String?,
        targetBeneficiaries: (taskMap['target_beneficiaries'] as int?) ?? 0,
        reachedBeneficiaries: (taskMap['reached_beneficiaries'] as int?) ?? 0,
        points: (taskMap['points'] as int?) ?? 0,
        members: members,
        objectives: objectives,
        supplies: supplies,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<String> createCampaign(Map<String, dynamic> data) async {
    try {
      final volunteerIds = data.remove('volunteer_ids') as List<String>? ?? [];
      final objectiveTitles = data.remove('objective_titles') as List<String>? ?? [];
      final suppliesData = data.remove('supplies_data') as List<Map<String, dynamic>>? ?? [];

      final response = await _client
          .from('tasks')
          .insert(data)
          .select('id')
          .single();
      final taskId = response['id'] as String;

      if (volunteerIds.isNotEmpty) {
        final adminId = data['created_by'] as String?;
        final campaignTitle = data['title'] as String? ?? '';
        final now = DateTime.now().toUtc().toIso8601String();
        final assignments = volunteerIds
            .map((uid) => {
                  'task_id': taskId,
                  'user_id': uid,
                  'status': 'assigned',
                  'assigned_at': now,
                  'assigned_by': adminId,
                })
            .toList();
        await _client.from('task_assignments').insert(assignments);

        // Notify each assigned volunteer
        if (adminId != null) {
          final notifications = volunteerIds
              .map((uid) => {
                    'admin_id': adminId,
                    'volunteer_id': uid,
                    'task_id': taskId,
                    'title': 'تم تعيينك في حملة جديدة',
                    'body': campaignTitle,
                    'is_read': false,
                    'created_at': now,
                  })
              .toList();
          await _client.from('admin_notes').insert(notifications);
        }
      }

      if (objectiveTitles.isNotEmpty) {
        final objectives = objectiveTitles
            .asMap()
            .entries
            .map((e) => {
                  'task_id': taskId,
                  'title': e.value,
                  'order_index': e.key,
                })
            .toList();
        await _client.from('task_objectives').insert(objectives);
      }

      if (suppliesData.isNotEmpty) {
        final supplies = suppliesData
            .map((s) => {...s, 'task_id': taskId})
            .toList();
        await _client.from('task_supplies').insert(supplies);
      }

      return taskId;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> updateCampaign(String id, Map<String, dynamic> data) async {
    try {
      final volunteerIds = data.remove('volunteer_ids') as List<String>?;
      final objectiveTitles = data.remove('objective_titles') as List<String>?;
      final suppliesData = data.remove('supplies_data') as List<Map<String, dynamic>>?;

      await _client.from('tasks').update(data).eq('id', id);

      if (volunteerIds != null) {
        await _client.from('task_assignments').delete().eq('task_id', id);
        if (volunteerIds.isNotEmpty) {
          final now = DateTime.now().toUtc().toIso8601String();
          final assignments = volunteerIds
              .map((uid) => {
                    'task_id': id,
                    'user_id': uid,
                    'status': 'assigned',
                    'assigned_at': now,
                  })
              .toList();
          await _client.from('task_assignments').insert(assignments);
        }
      }

      if (objectiveTitles != null) {
        await _client.from('task_objectives').delete().eq('task_id', id);
        if (objectiveTitles.isNotEmpty) {
          final objectives = objectiveTitles
              .asMap()
              .entries
              .map((e) => {
                    'task_id': id,
                    'title': e.value,
                    'order_index': e.key,
                  })
              .toList();
          await _client.from('task_objectives').insert(objectives);
        }
      }

      if (suppliesData != null) {
        await _client.from('task_supplies').delete().eq('task_id', id);
        if (suppliesData.isNotEmpty) {
          final supplies = suppliesData
              .map((s) => {...s, 'task_id': id})
              .toList();
          await _client.from('task_supplies').insert(supplies);
        }
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> deleteCampaign(String id) async {
    try {
      await _client.from('task_assignments').delete().eq('task_id', id);
      await _client.from('task_objectives').delete().eq('task_id', id);
      await _client.from('task_supplies').delete().eq('task_id', id);
      await _client.from('admin_notes').delete().eq('task_id', id);
      await _client.from('tasks').delete().eq('id', id);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> assignVolunteer({
    required String taskId,
    required String userId,
    required String adminId,
  }) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      await _client.from('task_assignments').insert({
        'task_id': taskId,
        'user_id': userId,
        'status': 'assigned',
        'assigned_at': now,
        'assigned_by': adminId,
      });

      // Fetch campaign title for the notification body
      final task = await _client
          .from('tasks')
          .select('title')
          .eq('id', taskId)
          .single();
      final campaignTitle = task['title'] as String? ?? '';

      await _client.from('admin_notes').insert({
        'admin_id': adminId,
        'volunteer_id': userId,
        'task_id': taskId,
        'title': 'تم تعيينك في حملة جديدة',
        'body': campaignTitle,
        'is_read': false,
        'created_at': now,
      });
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> removeVolunteer({
    required String taskId,
    required String userId,
  }) async {
    try {
      await _client
          .from('task_assignments')
          .delete()
          .eq('task_id', taskId)
          .eq('user_id', userId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> sendTeamAlert({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  }) async {
    try {
      if (volunteerIds.isEmpty) return;
      final now = DateTime.now().toUtc().toIso8601String();
      final notes = volunteerIds
          .map((uid) => {
                'admin_id': adminId,
                'volunteer_id': uid,
                'task_id': taskId,
                'title': title,
                'body': body,
                'is_read': false,
                'created_at': now,
              })
          .toList();
      await _client.from('admin_notes').insert(notes);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<List<VolunteerEntity>> getUnassignedVolunteers(String taskId) async {
    try {
      final assignedRes = await _client
          .from('task_assignments')
          .select('user_id')
          .eq('task_id', taskId);
      final assignedIds = (assignedRes as List)
          .map((a) => a['user_id'] as String)
          .toList();

      var query = _client
          .from('users')
          .select('id, name, avatar_url, rating, region')
          .inFilter('role', ['volunteer', 'user']);

      final allRes = await query;
      final all = (allRes as List)
          .where((u) => !assignedIds.contains(u['id'] as String))
          .map(
            (u) => VolunteerEntity(
              id: u['id'] as String,
              name: u['name'] as String? ?? '',
              avatarUrl: u['avatar_url'] as String?,
              rating: ((u['rating'] as num?) ?? 0).toDouble(),
              region: u['region'] as String?,
            ),
          )
          .toList();
      return all;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
