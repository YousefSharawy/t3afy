import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/ui_utiles.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/entities/campaign_detail_entity.dart';
import '../../domain/entities/campaign_member_entity.dart';
import '../../domain/entities/campaign_objective_entity.dart';
import '../../domain/entities/campaign_paper_entity.dart';
import '../../domain/entities/campaign_supply_entity.dart';
import '../../domain/entities/volunteer_entity.dart';
import 'campaigns_remote_datasource.dart';

class CampaignsRemoteDatasourceImpl implements CampaignsRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<List<CampaignEntity>> getCampaigns() async {
    try {
      const cacheKey = 'campaigns_list';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List).map<CampaignEntity>((m) {
          final e = Map<String, dynamic>.from(m as Map);
          return CampaignEntity(
            id: e['id'] as String,
            title: e['title'] as String? ?? '',
            type: e['type'] as String? ?? '',
            status: e['status'] as String? ?? 'upcoming',
            date: e['date'] as String? ?? '',
            timeStart: e['time_start'] as String?,
            timeEnd: e['time_end'] as String?,
            locationName: e['location_name'] as String?,
            locationAddress: e['location_address'] as String?,
            supervisorName: e['supervisor_name'] as String?,
            volunteerCount: e['volunteer_count'] as int? ?? 0,
            targetBeneficiaries: e['target_beneficiaries'] as int? ?? 0,
            reachedBeneficiaries: e['reached_beneficiaries'] as int? ?? 0,
            points: e['points'] as int? ?? 0,
          );
        }).toList();
      }

      final tasksRaw = await _client
          .from('tasks')
          .select()
          .order('date', ascending: false);

      final campaigns = <CampaignEntity>[];
      final cacheData = <Map<String, dynamic>>[];
      for (final t in tasksRaw as List) {
        final taskMap = t as Map<String, dynamic>;
        final taskId = taskMap['id'] as String;

        final assignRes = await _client
            .from('task_assignments')
            .select('id')
            .eq('task_id', taskId);
        final volunteerCount = (assignRes as List).length;

        final rawStatus = taskMap['status'] as String? ?? 'upcoming';
        final dateStr = taskMap['date'] as String?;
        final timeEndStr = taskMap['time_end'] as String?;
        final resolvedStatus = resolveCampaignStatus(rawStatus, dateStr, timeEndStr);

        campaigns.add(
          CampaignEntity(
            id: taskId,
            title: taskMap['title'] as String? ?? '',
            type: taskMap['type'] as String? ?? '',
            status: resolvedStatus,
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
        cacheData.add({
          'id': taskId,
          'title': taskMap['title'],
          'type': taskMap['type'],
          'status': resolvedStatus,
          'date': taskMap['date'],
          'time_start': taskMap['time_start'],
          'time_end': taskMap['time_end'],
          'location_name': taskMap['location_name'],
          'location_address': taskMap['location_address'],
          'supervisor_name': taskMap['supervisor_name'],
          'volunteer_count': volunteerCount,
          'target_beneficiaries': taskMap['target_beneficiaries'],
          'reached_beneficiaries': taskMap['reached_beneficiaries'],
          'points': taskMap['points'],
        });
      }
      await LocalAppStorage.setCache(cacheKey, cacheData,
          ttl: const Duration(minutes: 5));
      return campaigns;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<Map<String, int>> getCampaignStats() async {
    try {
      const cacheKey = 'campaigns_stats';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        final m = Map<String, dynamic>.from(cached as Map);
        return m.map((k, v) => MapEntry(k, v as int));
      }

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
          .inFilter('status', ['completed', 'done']);
      final doneCount = (doneRes as List).length;

      final result = {
        'notifications': unreadCount,
        'upcoming': upcomingCount,
        'done': doneCount,
      };
      await LocalAppStorage.setCache(cacheKey, result,
          ttl: const Duration(minutes: 5));
      return result;
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

      // Papers
      final papersRaw = await _client
          .from('task_papers')
          .select()
          .eq('task_id', id);
      final papers = (papersRaw as List)
          .map(
            (p) => CampaignPaperEntity(
              id: p['id'] as String,
              fileUrl: p['file_url'] as String? ?? '',
              fileName: p['file_name'] as String? ?? '',
            ),
          )
          .toList();

      // Members via task_assignments joined with users (include check-in fields)
      final assignmentsRaw = await _client
          .from('task_assignments')
          .select(
              'user_id, status, checked_in_at, checked_out_at, verified_hours, is_verified, users!task_assignments_user_id_fkey(id, name, avatar_url, rating, region, is_online, last_seen_at, role)')
          .eq('task_id', id);

      final members = <CampaignMemberEntity>[];
      for (final a in assignmentsRaw as List) {
        final u = a['users'] as Map<String, dynamic>?;
        if (u == null) continue;
        final lastSeenStr = u['last_seen_at'] as String?;
        final checkedInStr = a['checked_in_at'] as String?;
        final checkedOutStr = a['checked_out_at'] as String?;
        members.add(
          CampaignMemberEntity(
            id: u['id'] as String? ?? a['user_id'] as String,
            name: u['name'] as String? ?? '',
            avatarUrl: u['avatar_url'] as String?,
            rating: ((u['rating'] as num?) ?? 0).toDouble(),
            region: u['region'] as String?,
            isOnline: (u['is_online'] as bool?) ?? false,
            lastSeenAt: lastSeenStr != null ? DateTime.tryParse(lastSeenStr) : null,
            role: u['role'] as String? ?? 'user',
            checkedInAt: checkedInStr != null ? DateTime.tryParse(checkedInStr) : null,
            checkedOutAt: checkedOutStr != null ? DateTime.tryParse(checkedOutStr) : null,
            verifiedHours: ((a['verified_hours'] as num?) ?? 0).toDouble(),
            isVerified: (a['is_verified'] as bool?) ?? false,
          ),
        );
      }

      // Compute attendance summary
      final verifiedAttendanceCount = members.where((m) => m.isVerified).length;
      final totalVerifiedHours = members.fold<double>(
          0.0, (sum, m) => sum + (m.verifiedHours ?? 0.0));

      final detailDate = taskMap['date'] as String?;
      final detailTimeEnd = taskMap['time_end'] as String?;
      final detailStatus = resolveCampaignStatus(
        taskMap['status'] as String? ?? 'upcoming',
        detailDate,
        detailTimeEnd,
      );

      return CampaignDetailEntity(
        id: taskMap['id'] as String,
        title: taskMap['title'] as String? ?? '',
        type: taskMap['type'] as String? ?? '',
        status: detailStatus,
        date: (taskMap['date'] as String?) ?? '',
        timeStart: taskMap['time_start'] as String?,
        timeEnd: taskMap['time_end'] as String?,
        locationName: taskMap['location_name'] as String?,
        locationAddress: taskMap['location_address'] as String?,
        locationLat: (taskMap['location_lat'] as num?)?.toDouble(),
        locationLng: (taskMap['location_lng'] as num?)?.toDouble(),
        supervisorName: taskMap['supervisor_name'] as String?,
        supervisorPhone: taskMap['supervisor_phone'] as String?,
        description: taskMap['description'] as String?,
        notes: taskMap['notes'] as String?,
        targetBeneficiaries: (taskMap['target_beneficiaries'] as int?) ?? 0,
        reachedBeneficiaries: (taskMap['reached_beneficiaries'] as int?) ?? 0,
        points: (taskMap['points'] as int?) ?? 0,
        verifiedAttendanceCount: verifiedAttendanceCount,
        totalVerifiedHours: totalVerifiedHours,
        members: members,
        objectives: objectives,
        supplies: supplies,
        papers: papers,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  /// Parses "HH:MM" strings and returns the duration in decimal hours.
  /// Returns 0 if either string is invalid or end is not after start.
  double _durationHours(String timeStart, String timeEnd) {
    final sParts = timeStart.split(':');
    final eParts = timeEnd.split(':');
    if (sParts.length < 2 || eParts.length < 2) return 0;
    final startMins =
        (int.tryParse(sParts[0]) ?? 0) * 60 + (int.tryParse(sParts[1]) ?? 0);
    final endMins =
        (int.tryParse(eParts[0]) ?? 0) * 60 + (int.tryParse(eParts[1]) ?? 0);
    final diff = endMins - startMins;
    return diff > 0 ? diff / 60.0 : 0;
  }

  /// Credits a volunteer for a completed task: increments total_points,
  /// total_hours, total_tasks, and places_visited on the users row.
  Future<void> _creditVolunteer({
    required String volunteerId,
    required int points,
    required double durationHours,
  }) async {
    final userRow = await _client
        .from('users')
        .select('total_points, total_hours, total_tasks, places_visited')
        .eq('id', volunteerId)
        .single();
    final currentPoints = (userRow['total_points'] as num?)?.toInt() ?? 0;
    final currentHours = (userRow['total_hours'] as num?)?.toInt() ?? 0;
    final currentTasks = (userRow['total_tasks'] as num?)?.toInt() ?? 0;
    final currentPlaces = (userRow['places_visited'] as num?)?.toInt() ?? 0;
    await _client.from('users').update({
      'total_points': currentPoints + points,
      'total_hours': currentHours + durationHours.round(),
      'total_tasks': currentTasks + 1,
      'places_visited': currentPlaces + 1,
    }).eq('id', volunteerId);
  }

  /// Reverses a volunteer's credits for a completed task: subtracts points,
  /// hours, tasks count, and places_visited, clamped to a minimum of 0.
  Future<void> _reverseVolunteerCredit({
    required String volunteerId,
    required int points,
    required double durationHours,
  }) async {
    final userRow = await _client
        .from('users')
        .select('total_points, total_hours, total_tasks, places_visited')
        .eq('id', volunteerId)
        .single();
    final currentPoints = (userRow['total_points'] as num?)?.toInt() ?? 0;
    final currentHours = (userRow['total_hours'] as num?)?.toInt() ?? 0;
    final currentTasks = (userRow['total_tasks'] as num?)?.toInt() ?? 0;
    final currentPlaces = (userRow['places_visited'] as num?)?.toInt() ?? 0;
    await _client.from('users').update({
      'total_points': (currentPoints - points).clamp(0, double.maxFinite.toInt()),
      'total_hours': (currentHours - durationHours.round()).clamp(0, double.maxFinite.toInt()),
      'total_tasks': (currentTasks - 1).clamp(0, double.maxFinite.toInt()),
      'places_visited': (currentPlaces - 1).clamp(0, double.maxFinite.toInt()),
    }).eq('id', volunteerId);
  }

  @override
  Future<void> uploadCampaignPapers({
    required String taskId,
    required String adminId,
    required List<File> files,
  }) async {
    try {
      for (final file in files) {
        final originalName = file.path.split('/').last;
        final cleanFileName = originalName.replaceAll(RegExp(r'[^a-zA-Z0-9.]'), '_');
        final ext = cleanFileName.split('.').last.toLowerCase();
        final contentType = ext == 'pdf' ? 'application/pdf' : (ext == 'png' ? 'image/png' : 'image/jpeg');
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$cleanFileName';
        final path = '$taskId/$fileName';
        final bytes = await file.readAsBytes();
        await _client.storage.from('campaign-papers').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: contentType));
        final publicUrl = _client.storage.from('campaign-papers').getPublicUrl(path);
        await _client.from('task_papers').insert({
          'task_id': taskId,
          'file_url': publicUrl,
          'file_name': fileName,
          'uploaded_by': adminId,
          'uploaded_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<String> createCampaign(Map<String, dynamic> data) async {
    try {
      final timeStart = data['time_start'] as String?;
      final timeEnd = data['time_end'] as String?;
      if (timeStart == null || timeStart.isEmpty || timeEnd == null || timeEnd.isEmpty) {
        throw Failture(400, 'يجب تحديد وقت البداية والنهاية');
      }

      data['duration_hours'] = _durationHours(timeStart, timeEnd);

      final rawPoints = data['points'];
      if (rawPoints == null || (rawPoints is int && rawPoints == 0)) {
        data['points'] = 10;
      }

      final volunteerIds = data.remove('volunteer_ids') as List<String>? ?? [];
      final objectiveTitles = data.remove('objective_titles') as List<String>? ?? [];
      final suppliesData = data.remove('supplies_data') as List<Map<String, dynamic>>? ?? [];
      final paperFiles = data.remove('paper_files') as List<File>? ?? [];

      final response = await _client
          .from('tasks')
          .insert(data)
          .select('id')
          .single();
      final taskId = response['id'] as String;

      final isCompleted = (data['status'] as String?) == 'completed';
      final taskPoints = (data['points'] as int?) ?? 10;
      final taskHours = (data['duration_hours'] as num?)?.toDouble() ?? 0.0;

      if (volunteerIds.isNotEmpty) {
        final adminId = data['created_by'] as String?;
        final campaignTitle = data['title'] as String? ?? '';
        final now = DateTime.now().toUtc().toIso8601String();
        final assignmentStatus = isCompleted ? 'completed' : 'assigned';
        final assignments = volunteerIds
            .map((uid) => {
                  'task_id': taskId,
                  'user_id': uid,
                  'status': assignmentStatus,
                  'assigned_at': now,
                  'assigned_by': adminId,
                })
            .toList();
        await _client.from('task_assignments').insert(assignments);

        if (isCompleted) {
          for (final uid in volunteerIds) {
            await _creditVolunteer(
              volunteerId: uid,
              points: taskPoints,
              durationHours: taskHours,
            );
            await LocalAppStorage.invalidateCache('completed_tasks_$uid');
            await LocalAppStorage.invalidateCache('tasks_stats_$uid');
            await LocalAppStorage.invalidateCache('vol_stats_v2_$uid');
          }
        }

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

      if (paperFiles.isNotEmpty) {
        final adminId = data['created_by'] as String? ?? '';
        await uploadCampaignPapers(
          taskId: taskId,
          adminId: adminId,
          files: paperFiles,
        );
      }

      await LocalAppStorage.invalidateCache('campaigns_list');
      await LocalAppStorage.invalidateCache('campaigns_stats');
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
      final paperFiles = data.remove('paper_files') as List<File>? ?? [];
      final adminId = data.remove('updated_by') as String? ?? '';

      final timeStart = data['time_start'] as String?;
      final timeEnd = data['time_end'] as String?;
      if (timeStart != null && timeStart.isNotEmpty &&
          timeEnd != null && timeEnd.isNotEmpty) {
        data['duration_hours'] = _durationHours(timeStart, timeEnd);
      }

      await _client.from('tasks').update(data).eq('id', id);

      if (volunteerIds != null) {
        // Fetch task stats before deleting assignments so we can reverse credits
        final taskRow = await _client
            .from('tasks')
            .select('status, points, duration_hours')
            .eq('id', id)
            .single();
        final taskPoints = (taskRow['points'] as num?)?.toInt() ?? 10;
        final taskHours = (taskRow['duration_hours'] as num?)?.toDouble() ?? 0.0;

        // Reverse credits for any previously completed assignments
        final prevCompleted = await _client
            .from('task_assignments')
            .select('user_id')
            .eq('task_id', id)
            .eq('status', 'completed');
        for (final row in prevCompleted as List) {
          final uid = row['user_id'] as String;
          await _reverseVolunteerCredit(
            volunteerId: uid,
            points: taskPoints,
            durationHours: taskHours,
          );
          await LocalAppStorage.invalidateCache('completed_tasks_$uid');
          await LocalAppStorage.invalidateCache('tasks_stats_$uid');
          await LocalAppStorage.invalidateCache('vol_stats_v2_$uid');
        }

        await _client.from('task_assignments').delete().eq('task_id', id);

        if (volunteerIds.isNotEmpty) {
          final isCompleted = (taskRow['status'] as String?) == 'completed';
          final assignmentStatus = isCompleted ? 'completed' : 'assigned';

          final now = DateTime.now().toUtc().toIso8601String();
          final assignments = volunteerIds
              .map((uid) => {
                    'task_id': id,
                    'user_id': uid,
                    'status': assignmentStatus,
                    'assigned_at': now,
                  })
              .toList();
          await _client.from('task_assignments').insert(assignments);

          if (isCompleted) {
            for (final uid in volunteerIds) {
              await _creditVolunteer(
                volunteerId: uid,
                points: taskPoints,
                durationHours: taskHours,
              );
              await LocalAppStorage.invalidateCache('completed_tasks_$uid');
              await LocalAppStorage.invalidateCache('tasks_stats_$uid');
              await LocalAppStorage.invalidateCache('vol_stats_v2_$uid');
            }
          }
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

      if (paperFiles.isNotEmpty) {
        await uploadCampaignPapers(
          taskId: id,
          adminId: adminId,
          files: paperFiles,
        );
      }

      await LocalAppStorage.invalidateCache('campaigns_list');
      await LocalAppStorage.invalidateCache('campaigns_stats');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> deleteCampaign(String id) async {
    try {
      // Fetch task stats before deletion to reverse credits
      final taskRow = await _client
          .from('tasks')
          .select('points, duration_hours')
          .eq('id', id)
          .single();
      final taskPoints = (taskRow['points'] as num?)?.toInt() ?? 0;
      final taskHours = (taskRow['duration_hours'] as num?)?.toDouble() ?? 0.0;

      // Reverse credits for all volunteers with completed assignments
      final completedAssignments = await _client
          .from('task_assignments')
          .select('user_id')
          .eq('task_id', id)
          .eq('status', 'completed');
      for (final row in completedAssignments as List) {
        final uid = row['user_id'] as String;
        await _reverseVolunteerCredit(
          volunteerId: uid,
          points: taskPoints,
          durationHours: taskHours,
        );
        await LocalAppStorage.invalidateCache('completed_tasks_$uid');
        await LocalAppStorage.invalidateCache('tasks_stats_$uid');
        await LocalAppStorage.invalidateCache('vol_stats_v2_$uid');
      }

      // Delete campaign papers from storage and table
      final papersRaw = await _client
          .from('task_papers')
          .select('file_url')
          .eq('task_id', id);
      for (final p in papersRaw as List) {
        final url = p['file_url'] as String? ?? '';
        // Extract path: everything after /campaign-papers/
        final marker = '/campaign-papers/';
        final markerIdx = url.indexOf(marker);
        if (markerIdx != -1) {
          final storagePath = url.substring(markerIdx + marker.length);
          try {
            await _client.storage.from('campaign-papers').remove([storagePath]);
          } catch (_) {}
        }
      }
      await _client.from('task_papers').delete().eq('task_id', id);

      await _client.from('task_assignments').delete().eq('task_id', id);
      await _client.from('task_objectives').delete().eq('task_id', id);
      await _client.from('task_supplies').delete().eq('task_id', id);
      await _client.from('admin_notes').delete().eq('task_id', id);
      await _client.from('tasks').delete().eq('id', id);
      await LocalAppStorage.invalidateCache('campaigns_list');
      await LocalAppStorage.invalidateCache('campaigns_stats');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> assignVolunteers({
    required String taskId,
    required List<String> userIds,
    required String adminId,
  }) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();

      // Fetch task info needed for status check, credits, and notifications
      final task = await _client
          .from('tasks')
          .select('title, status, points, duration_hours')
          .eq('id', taskId)
          .single();
      final campaignTitle = task['title'] as String? ?? '';
      final isCompleted = (task['status'] as String?) == 'completed';
      final taskPoints = (task['points'] as num?)?.toInt() ?? 10;
      final taskHours = (task['duration_hours'] as num?)?.toDouble() ?? 0.0;

      final assignmentStatus = isCompleted ? 'completed' : 'assigned';
      final assignments = userIds
          .map((id) => {
                'task_id': taskId,
                'user_id': id,
                'status': assignmentStatus,
                'assigned_at': now,
                'assigned_by': adminId,
              })
          .toList();
      await _client.from('task_assignments').insert(assignments);

      if (isCompleted) {
        for (final uid in userIds) {
          await _creditVolunteer(
            volunteerId: uid,
            points: taskPoints,
            durationHours: taskHours,
          );
        }
      }

      final notes = userIds
          .map((id) => {
                'admin_id': adminId,
                'volunteer_id': id,
                'task_id': taskId,
                'title': 'تم تعيينك في حملة جديدة',
                'body': campaignTitle,
                'is_read': false,
                'created_at': now,
              })
          .toList();
      await _client.from('admin_notes').insert(notes);
      await LocalAppStorage.invalidateCache('campaigns_list');
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
      // Check assignment status before deleting
      final assignmentRes = await _client
          .from('task_assignments')
          .select('status')
          .eq('task_id', taskId)
          .eq('user_id', userId)
          .maybeSingle();
      if (assignmentRes != null &&
          (assignmentRes['status'] as String?) == 'completed') {
        final taskRow = await _client
            .from('tasks')
            .select('points, duration_hours')
            .eq('id', taskId)
            .single();
        await _reverseVolunteerCredit(
          volunteerId: userId,
          points: (taskRow['points'] as num?)?.toInt() ?? 0,
          durationHours: (taskRow['duration_hours'] as num?)?.toDouble() ?? 0.0,
        );
      }

      await _client
          .from('task_assignments')
          .delete()
          .eq('task_id', taskId)
          .eq('user_id', userId);
      await LocalAppStorage.invalidateCache('campaigns_list');
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
  RealtimeChannel subscribeCampaignsChanges(void Function() onChanged) {
    return _client
        .channel('tasks_changes_campaigns')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          callback: (_) => onChanged(),
        )
        .subscribe();
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

  @override
  Future<List<VolunteerEntity>> getAllVolunteers() async {
    try {
      const cacheKey = 'all_volunteers';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List).map<VolunteerEntity>((u) {
          final m = Map<String, dynamic>.from(u as Map);
          return VolunteerEntity(
            id: m['id'] as String,
            name: m['name'] as String? ?? '',
            avatarUrl: m['avatar_url'] as String?,
            rating: ((m['rating'] as num?) ?? 0).toDouble(),
            region: m['region'] as String?,
          );
        }).toList();
      }

      final res = await _client
          .from('users')
          .select('id, name, avatar_url, rating, region')
          .inFilter('role', ['volunteer', 'user']);
      await LocalAppStorage.setCache(cacheKey, res,
          ttl: const Duration(minutes: 5));
      return (res as List)
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
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
