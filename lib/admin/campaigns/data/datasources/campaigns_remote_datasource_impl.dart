import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/app_const.dart';
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

  static const _listCacheKey = 'campaigns_list';
  static const _statsCacheKey = 'campaigns_stats';

  /// Only the columns the list uses, plus the assignments embedded in the same
  /// request (this used to be one extra round trip per campaign).
  static const _listColumns =
      'id, title, type, status, date, time_start, time_end, location_name, '
      'location_address, supervisor_name, target_beneficiaries, '
      'reached_beneficiaries, points, task_assignments(status, checked_in_at)';

  static CampaignEntity _campaignFromCache(Map<String, dynamic> e) {
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
      attendedCount: e['attended_count'] as int? ?? 0,
      targetBeneficiaries: e['target_beneficiaries'] as int? ?? 0,
      reachedBeneficiaries: e['reached_beneficiaries'] as int? ?? 0,
      points: e['points'] as int? ?? 0,
    );
  }

  Future<void> _invalidateListCaches() => Future.wait([
    LocalAppStorage.invalidateCache(_listCacheKey),
    LocalAppStorage.invalidateCache(_statsCacheKey),
  ]);

  Future<void> _invalidateVolunteerCaches(String uid) => Future.wait([
    LocalAppStorage.invalidateCache('completed_tasks_$uid'),
    LocalAppStorage.invalidateCache('tasks_stats_$uid'),
    LocalAppStorage.invalidateCache('vol_stats_v2_$uid'),
  ]);

  @override
  Future<List<CampaignEntity>> getCampaigns({bool skipCache = false}) async {
    try {
      if (!skipCache) {
        final cached = LocalAppStorage.getCache(_listCacheKey);
        if (cached != null) {
          return (cached as List)
              .map((m) => _campaignFromCache(Map<String, dynamic>.from(m as Map)))
              .toList();
        }
      }

      final tasksRaw = await _client
          .from('tasks')
          .select(_listColumns)
          .order('date', ascending: false);

      final cacheData = <Map<String, dynamic>>[];
      for (final t in tasksRaw as List) {
        final taskMap = t as Map<String, dynamic>;
        final assignments = (taskMap['task_assignments'] as List?) ?? const [];
        final attended = assignments.where((a) {
          final m = a as Map<String, dynamic>;
          return m['checked_in_at'] != null || m['status'] == 'completed';
        }).length;
        cacheData.add({
          'id': taskMap['id'],
          'title': taskMap['title'],
          'type': taskMap['type'],
          'status': resolveCampaignStatus(
            taskMap['status'] as String? ?? 'upcoming',
            taskMap['date'] as String?,
            taskMap['time_end'] as String?,
          ),
          'date': taskMap['date'],
          'time_start': taskMap['time_start'],
          'time_end': taskMap['time_end'],
          'location_name': taskMap['location_name'],
          'location_address': taskMap['location_address'],
          'supervisor_name': taskMap['supervisor_name'],
          'volunteer_count': assignments.length,
          'attended_count': attended,
          'target_beneficiaries': taskMap['target_beneficiaries'],
          'reached_beneficiaries': taskMap['reached_beneficiaries'],
          'points': taskMap['points'],
        });
      }
      await LocalAppStorage.setCache(
        _listCacheKey,
        cacheData,
        ttl: const Duration(minutes: 5),
      );
      return cacheData.map(_campaignFromCache).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  /// Status counts come from the same resolved-status list the screen shows,
  /// so a stat and its chip can never disagree. `notifications` is the
  /// manager's own unread count (same definition as the notifications screen).
  @override
  Future<Map<String, int>> getCampaignStats({bool skipCache = false}) async {
    try {
      if (!skipCache) {
        final cached = LocalAppStorage.getCache(_statsCacheKey);
        if (cached != null) {
          final m = Map<String, dynamic>.from(cached as Map);
          return m.map((k, v) => MapEntry(k, v as int));
        }
      }

      final adminId = LocalAppStorage.getUserId() ?? '';
      final results = await Future.wait<Object>([
        getCampaigns(skipCache: skipCache),
        _client
            .from('admin_notes')
            .select('id')
            .eq('admin_id', adminId)
            .eq('volunteer_id', adminId)
            .eq('is_read', false)
            .count(CountOption.exact),
      ]);
      final campaigns = results[0] as List<CampaignEntity>;
      final unread = (results[1] as PostgrestResponse).count;

      final result = {
        ...CampaignEntity.countByFilter(campaigns),
        'notifications': unread,
      };
      await LocalAppStorage.setCache(
        _statsCacheKey,
        result,
        ttl: const Duration(minutes: 5),
      );
      return result;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<CampaignDetailEntity> getCampaignDetail(String id) async {
    try {
      final results = await Future.wait<dynamic>([
        _client.from('tasks').select().eq('id', id).single(),
        _client
            .from('task_objectives')
            .select('id, title, order_index')
            .eq('task_id', id)
            .order('order_index'),
        _client
            .from('task_supplies')
            .select('id, name, quantity')
            .eq('task_id', id),
        _client
            .from('task_papers')
            .select('id, file_url, file_name')
            .eq('task_id', id),
        _client
            .from('task_assignments')
            .select(
              'user_id, status, checked_in_at, checked_out_at, check_in_lat, check_in_lng, check_out_lat, check_out_lng, verified_hours, is_verified, users!task_assignments_user_id_fkey(id, name, avatar_url, rating, region, is_online, last_seen_at, role)',
            )
            .eq('task_id', id),
      ]);

      final taskMap = results[0] as Map<String, dynamic>;

      final objectives = (results[1] as List)
          .map(
            (o) => CampaignObjectiveEntity(
              id: o['id'] as String,
              title: o['title'] as String? ?? '',
              orderIndex: (o['order_index'] as int?) ?? 0,
            ),
          )
          .toList();

      final supplies = (results[2] as List)
          .map(
            (s) => CampaignSupplyEntity(
              id: s['id'] as String,
              name: s['name'] as String? ?? '',
              quantity: (s['quantity'] as int?) ?? 1,
            ),
          )
          .toList();

      final papers = (results[3] as List)
          .map(
            (p) => CampaignPaperEntity(
              id: p['id'] as String,
              fileUrl: p['file_url'] as String? ?? '',
              fileName: p['file_name'] as String? ?? '',
            ),
          )
          .toList();

      final members = <CampaignMemberEntity>[];
      for (final a in results[4] as List) {
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
            lastSeenAt: lastSeenStr != null
                ? DateTime.tryParse(lastSeenStr)
                : null,
            role: u['role'] as String? ?? 'user',
            checkedInAt: checkedInStr != null
                ? DateTime.tryParse(checkedInStr)
                : null,
            checkedOutAt: checkedOutStr != null
                ? DateTime.tryParse(checkedOutStr)
                : null,
            checkInLat: (a['check_in_lat'] as num?)?.toDouble(),
            checkInLng: (a['check_in_lng'] as num?)?.toDouble(),
            checkOutLat: (a['check_out_lat'] as num?)?.toDouble(),
            checkOutLng: (a['check_out_lng'] as num?)?.toDouble(),
            verifiedHours: ((a['verified_hours'] as num?) ?? 0).toDouble(),
            assignmentStatus: a['status'] as String? ?? '',
            isVerified: (a['is_verified'] as bool?) ?? false,
          ),
        );
      }

      final verifiedAttendanceCount = members.where((m) => m.isVerified).length;
      final totalVerifiedHours = members.fold<double>(
        0.0,
        (sum, m) => sum + (m.verifiedHours ?? 0.0),
      );

      return CampaignDetailEntity(
        id: taskMap['id'] as String,
        title: taskMap['title'] as String? ?? '',
        type: taskMap['type'] as String? ?? '',
        status: resolveCampaignStatus(
          taskMap['status'] as String? ?? 'upcoming',
          taskMap['date'] as String?,
          taskMap['time_end'] as String?,
        ),
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
  /// Guard: an assignment already marked 'completed' has been credited, so it
  /// is skipped (prevents double-crediting).
  Future<void> _creditVolunteer({
    required String volunteerId,
    required String taskId,
    required int points,
    required double durationHours,
  }) async {
    final assignmentCheck = await _client
        .from('task_assignments')
        .select('status')
        .eq('task_id', taskId)
        .eq('user_id', volunteerId)
        .maybeSingle();

    if (assignmentCheck != null &&
        (assignmentCheck['status'] as String?) == 'completed') {
      return;
    }

    final userRow = await _client
        .from('users')
        .select('total_points, total_hours, total_tasks, places_visited')
        .eq('id', volunteerId)
        .single();
    final currentPoints = (userRow['total_points'] as num?)?.toInt() ?? 0;
    final currentHours = (userRow['total_hours'] as num?)?.toInt() ?? 0;
    final currentTasks = (userRow['total_tasks'] as num?)?.toInt() ?? 0;
    final currentPlaces = (userRow['places_visited'] as num?)?.toInt() ?? 0;
    await _client
        .from('users')
        .update({
          'total_points': currentPoints + points,
          'total_hours': currentHours + durationHours.round(),
          'total_tasks': currentTasks + 1,
          'places_visited': currentPlaces + 1,
        })
        .eq('id', volunteerId);
  }

  /// Inserts fresh assignments for a campaign that is already completed and
  /// credits each volunteer exactly once.
  ///
  /// Rows go in as 'assigned' first: [_creditVolunteer] skips anything already
  /// 'completed', so inserting them as completed (the old behaviour) meant no
  /// one was ever credited. Each row is flipped to 'completed' only after its
  /// credit succeeds, so a retry after a partial failure can't double-credit.
  Future<void> _insertCompletedAssignments({
    required String taskId,
    required List<Map<String, dynamic>> rows,
    required int points,
    required double durationHours,
  }) async {
    await _client.from('task_assignments').insert([
      for (final r in rows) {...r, 'status': 'assigned'},
    ]);
    await Future.wait(
      rows.map((r) async {
        final uid = r['user_id'] as String;
        await _creditVolunteer(
          volunteerId: uid,
          taskId: taskId,
          points: points,
          durationHours: durationHours,
        );
        await _client
            .from('task_assignments')
            .update({'status': 'completed'})
            .eq('task_id', taskId)
            .eq('user_id', uid);
        await _invalidateVolunteerCaches(uid);
      }),
    );
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
    int floor0(int v) => v < 0 ? 0 : v;
    final currentPoints = (userRow['total_points'] as num?)?.toInt() ?? 0;
    final currentHours = (userRow['total_hours'] as num?)?.toInt() ?? 0;
    final currentTasks = (userRow['total_tasks'] as num?)?.toInt() ?? 0;
    final currentPlaces = (userRow['places_visited'] as num?)?.toInt() ?? 0;
    await _client
        .from('users')
        .update({
          'total_points': floor0(currentPoints - points),
          'total_hours': floor0(currentHours - durationHours.round()),
          'total_tasks': floor0(currentTasks - 1),
          'places_visited': floor0(currentPlaces - 1),
        })
        .eq('id', volunteerId);
  }

  Future<void> _reverseCredits(
    List<String> userIds, {
    required int points,
    required double durationHours,
  }) {
    return Future.wait(
      userIds.map((uid) async {
        await _reverseVolunteerCredit(
          volunteerId: uid,
          points: points,
          durationHours: durationHours,
        );
        await _invalidateVolunteerCaches(uid);
      }),
    );
  }

  @override
  Future<void> uploadCampaignPapers({
    required String taskId,
    required String adminId,
    required List<File> files,
  }) async {
    try {
      if (files.isEmpty) return;
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final rows = await Future.wait(
        files.asMap().entries.map((entry) async {
          final originalName = entry.value.path.split('/').last;
          final cleanFileName = originalName.replaceAll(
            RegExp(r'[^a-zA-Z0-9.]'),
            '_',
          );
          final ext = cleanFileName.split('.').last.toLowerCase();
          final contentType = ext == 'pdf'
              ? 'application/pdf'
              : (ext == 'png' ? 'image/png' : 'image/jpeg');
          // Index keeps names unique now that files upload in parallel.
          final fileName = '${stamp}_${entry.key}_$cleanFileName';
          final path = '$taskId/$fileName';
          final bytes = await entry.value.readAsBytes();
          final bucket = _client.storage.from(StorageBuckets.campaignPapers);
          await bucket.uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: contentType),
          );
          return {
            'task_id': taskId,
            'file_url': bucket.getPublicUrl(path),
            'file_name': fileName,
            'uploaded_by': adminId,
            'uploaded_at': DateTime.now().toUtc().toIso8601String(),
          };
        }),
      );
      await _client.from('task_papers').insert(rows);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  Future<void> _replaceObjectives(String taskId, List<String> titles, {bool clear = true}) async {
    if (clear) {
      await _client.from('task_objectives').delete().eq('task_id', taskId);
    }
    if (titles.isEmpty) return;
    await _client.from('task_objectives').insert([
      for (final e in titles.asMap().entries)
        {'task_id': taskId, 'title': e.value, 'order_index': e.key},
    ]);
  }

  Future<void> _replaceSupplies(
    String taskId,
    List<Map<String, dynamic>> supplies, {
    bool clear = true,
  }) async {
    if (clear) {
      await _client.from('task_supplies').delete().eq('task_id', taskId);
    }
    if (supplies.isEmpty) return;
    await _client.from('task_supplies').insert([
      for (final s in supplies) {...s, 'task_id': taskId},
    ]);
  }

  List<Map<String, dynamic>> _assignmentNotes({
    required String adminId,
    required String taskId,
    required List<String> userIds,
    required String title,
    required String body,
    required String now,
  }) => [
    for (final uid in userIds)
      {
        'admin_id': adminId,
        'volunteer_id': uid,
        'task_id': taskId,
        'title': title,
        'body': body,
        'is_read': false,
        'created_at': now,
      },
  ];

  @override
  Future<String> createCampaign(Map<String, dynamic> data) async {
    try {
      final timeStart = data['time_start'] as String?;
      final timeEnd = data['time_end'] as String?;
      if (timeStart == null ||
          timeStart.isEmpty ||
          timeEnd == null ||
          timeEnd.isEmpty) {
        throw Failture(400, 'يجب تحديد وقت البداية والنهاية');
      }

      data['duration_hours'] = _durationHours(timeStart, timeEnd);

      final rawPoints = data['points'];
      if (rawPoints == null || (rawPoints is int && rawPoints == 0)) {
        data['points'] = 10;
      }

      final volunteerIds = data.remove('volunteer_ids') as List<String>? ?? [];
      final objectiveTitles =
          data.remove('objective_titles') as List<String>? ?? [];
      final suppliesData =
          data.remove('supplies_data') as List<Map<String, dynamic>>? ?? [];
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
      final adminId = data['created_by'] as String?;

      Future<void> assign() async {
        if (volunteerIds.isEmpty) return;
        final now = DateTime.now().toUtc().toIso8601String();
        final rows = [
          for (final uid in volunteerIds)
            {
              'task_id': taskId,
              'user_id': uid,
              'status': 'assigned',
              'assigned_at': now,
              'assigned_by': adminId,
            },
        ];
        await Future.wait([
          if (isCompleted)
            _insertCompletedAssignments(
              taskId: taskId,
              rows: rows,
              points: taskPoints,
              durationHours: taskHours,
            )
          else
            _client.from('task_assignments').insert(rows),
          if (adminId != null)
            _client
                .from('admin_notes')
                .insert(
                  _assignmentNotes(
                    adminId: adminId,
                    taskId: taskId,
                    userIds: volunteerIds,
                    title: 'تم تعيينك في حملة جديدة',
                    body: data['title'] as String? ?? '',
                    now: now,
                  ),
                ),
        ]);
      }

      // Everything below only depends on the task row existing.
      await Future.wait([
        assign(),
        _replaceObjectives(taskId, objectiveTitles, clear: false),
        _replaceSupplies(taskId, suppliesData, clear: false),
        uploadCampaignPapers(
          taskId: taskId,
          adminId: adminId ?? '',
          files: paperFiles,
        ),
      ]);

      await _invalidateListCaches();
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
      final suppliesData =
          data.remove('supplies_data') as List<Map<String, dynamic>>?;
      final paperFiles = data.remove('paper_files') as List<File>? ?? [];
      final adminId = data.remove('updated_by') as String? ?? '';

      final timeStart = data['time_start'] as String?;
      final timeEnd = data['time_end'] as String?;
      if (timeStart != null &&
          timeStart.isNotEmpty &&
          timeEnd != null &&
          timeEnd.isNotEmpty) {
        data['duration_hours'] = _durationHours(timeStart, timeEnd);
      }

      await _client.from('tasks').update(data).eq('id', id);

      Future<void> reassign() async {
        if (volunteerIds == null) return;
        final pre = await Future.wait<dynamic>([
          _client
              .from('tasks')
              .select('status, points, duration_hours')
              .eq('id', id)
              .single(),
          _client
              .from('task_assignments')
              .select('user_id')
              .eq('task_id', id)
              .eq('status', 'completed'),
        ]);
        final taskRow = pre[0] as Map<String, dynamic>;
        final taskPoints = (taskRow['points'] as num?)?.toInt() ?? 10;
        final taskHours =
            (taskRow['duration_hours'] as num?)?.toDouble() ?? 0.0;

        // Re-saving replaces the whole team: undo every earlier credit first,
        // then credit the new team once (if the campaign is completed).
        await _reverseCredits(
          [for (final r in pre[1] as List) r['user_id'] as String],
          points: taskPoints,
          durationHours: taskHours,
        );
        await _client.from('task_assignments').delete().eq('task_id', id);
        if (volunteerIds.isEmpty) return;

        final now = DateTime.now().toUtc().toIso8601String();
        final rows = [
          for (final uid in volunteerIds)
            {
              'task_id': id,
              'user_id': uid,
              'status': 'assigned',
              'assigned_at': now,
            },
        ];
        if ((taskRow['status'] as String?) == 'completed') {
          await _insertCompletedAssignments(
            taskId: id,
            rows: rows,
            points: taskPoints,
            durationHours: taskHours,
          );
        } else {
          await _client.from('task_assignments').insert(rows);
        }
      }

      await Future.wait([
        reassign(),
        if (objectiveTitles != null) _replaceObjectives(id, objectiveTitles),
        if (suppliesData != null) _replaceSupplies(id, suppliesData),
        uploadCampaignPapers(taskId: id, adminId: adminId, files: paperFiles),
      ]);

      await _invalidateListCaches();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> deleteCampaign(String id) async {
    try {
      final pre = await Future.wait<dynamic>([
        _client
            .from('tasks')
            .select('points, duration_hours')
            .eq('id', id)
            .single(),
        _client
            .from('task_assignments')
            .select('user_id')
            .eq('task_id', id)
            .eq('status', 'completed'),
        _client.from('task_papers').select('file_url').eq('task_id', id),
      ]);
      final taskRow = pre[0] as Map<String, dynamic>;

      const marker = '/campaign-papers/';
      final storagePaths = <String>[
        for (final p in pre[2] as List)
          if ((p['file_url'] as String? ?? '').contains(marker))
            (p['file_url'] as String).substring(
              (p['file_url'] as String).indexOf(marker) + marker.length,
            ),
      ];

      Future<void> removeFiles() async {
        if (storagePaths.isEmpty) return;
        try {
          await _client.storage
              .from(StorageBuckets.campaignPapers)
              .remove(storagePaths);
        } catch (_) {}
      }

      await Future.wait([
        _reverseCredits(
          [for (final r in pre[1] as List) r['user_id'] as String],
          points: (taskRow['points'] as num?)?.toInt() ?? 0,
          durationHours: (taskRow['duration_hours'] as num?)?.toDouble() ?? 0.0,
        ),
        removeFiles(),
      ]);

      // Child rows first (in parallel), then the task itself.
      await Future.wait([
        _client.from('task_papers').delete().eq('task_id', id),
        _client.from('task_assignments').delete().eq('task_id', id),
        _client.from('task_objectives').delete().eq('task_id', id),
        _client.from('task_supplies').delete().eq('task_id', id),
        _client.from('admin_notes').delete().eq('task_id', id),
      ]);
      await _client.from('tasks').delete().eq('id', id);
      await _invalidateListCaches();
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
      if (userIds.isEmpty) return;
      final now = DateTime.now().toUtc().toIso8601String();

      final task = await _client
          .from('tasks')
          .select('title, status, points, duration_hours')
          .eq('id', taskId)
          .single();
      final isCompleted = (task['status'] as String?) == 'completed';
      final rows = [
        for (final uid in userIds)
          {
            'task_id': taskId,
            'user_id': uid,
            'status': 'assigned',
            'assigned_at': now,
            'assigned_by': adminId,
          },
      ];

      await Future.wait([
        if (isCompleted)
          _insertCompletedAssignments(
            taskId: taskId,
            rows: rows,
            points: (task['points'] as num?)?.toInt() ?? 10,
            durationHours: (task['duration_hours'] as num?)?.toDouble() ?? 0.0,
          )
        else
          _client.from('task_assignments').insert(rows),
        _client
            .from('admin_notes')
            .insert(
              _assignmentNotes(
                adminId: adminId,
                taskId: taskId,
                userIds: userIds,
                title: 'تم تعيينك في حملة جديدة',
                body: task['title'] as String? ?? '',
                now: now,
              ),
            ),
      ]);
      await _invalidateListCaches();
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
      final pre = await Future.wait<dynamic>([
        _client
            .from('task_assignments')
            .select('status')
            .eq('task_id', taskId)
            .eq('user_id', userId)
            .maybeSingle(),
        _client
            .from('tasks')
            .select('points, duration_hours')
            .eq('id', taskId)
            .single(),
      ]);
      final assignment = pre[0] as Map<String, dynamic>?;
      if (assignment != null &&
          (assignment['status'] as String?) == 'completed') {
        final taskRow = pre[1] as Map<String, dynamic>;
        await _reverseCredits(
          [userId],
          points: (taskRow['points'] as num?)?.toInt() ?? 0,
          durationHours: (taskRow['duration_hours'] as num?)?.toDouble() ?? 0.0,
        );
      }

      await _client
          .from('task_assignments')
          .delete()
          .eq('task_id', taskId)
          .eq('user_id', userId);
      await _invalidateListCaches();
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
      await _client
          .from('admin_notes')
          .insert(
            _assignmentNotes(
              adminId: adminId,
              taskId: taskId,
              userIds: volunteerIds,
              title: title,
              body: body,
              now: DateTime.now().toUtc().toIso8601String(),
            ),
          );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  /// Kept for the interface; the campaigns cubit now listens through
  /// RealtimeHub (debounced, removeChannel on close).
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

  static VolunteerEntity _volunteerFromRow(Map<String, dynamic> m) =>
      VolunteerEntity(
        id: m['id'] as String,
        name: m['name'] as String? ?? '',
        avatarUrl: m['avatar_url'] as String?,
        rating: ((m['rating'] as num?) ?? 0).toDouble(),
        region: m['region'] as String?,
      );

  @override
  Future<List<VolunteerEntity>> getUnassignedVolunteers(String taskId) async {
    try {
      final results = await Future.wait<dynamic>([
        _client.from('task_assignments').select('user_id').eq('task_id', taskId),
        _client
            .from('users')
            .select('id, name, avatar_url, rating, region')
            .inFilter('role', ['volunteer', 'user']),
      ]);
      final assignedIds = {
        for (final a in results[0] as List) a['user_id'] as String,
      };
      return (results[1] as List)
          .where((u) => !assignedIds.contains(u['id'] as String))
          .map((u) => _volunteerFromRow(u as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<List<VolunteerEntity>> getAllVolunteers({bool skipCache = false}) async {
    try {
      const cacheKey = 'all_volunteers';
      if (!skipCache) {
        final cached = LocalAppStorage.getCache(cacheKey);
        if (cached != null) {
          return (cached as List)
              .map((u) => _volunteerFromRow(Map<String, dynamic>.from(u as Map)))
              .toList();
        }
      }

      final res = await _client
          .from('users')
          .select('id, name, avatar_url, rating, region')
          .inFilter('role', ['volunteer', 'user']);
      await LocalAppStorage.setCache(
        cacheKey,
        res,
        ttl: const Duration(minutes: 5),
      );
      return (res as List)
          .map((u) => _volunteerFromRow(u as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
