import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/volunteers/data/datasources/volunteers_remote_datasource.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

class VolunteersRemoteDatasourceImpl implements VolunteersRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  RealtimeChannel subscribeOnlineStatus(void Function() onChanged) {
    return _client
        .channel('users_online_status_volunteers')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'users',
          callback: (_) => onChanged(),
        )
        .subscribe();
  }

  @override
  Future<List<AdminVolunteerEntity>> getPendingUsers() async {
    try {
      final data = await _client
          .from('users')
          .select(
            'id, name, avatar_url, rating, region, total_hours, total_tasks, is_online, last_seen_at, role',
          )
          .eq('role', 'user')
          .order('joined_at', ascending: false);
      return (data as List)
          .map((e) => AdminVolunteerEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> addVolunteer({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  }) async {
    try {
      await _client.from('users').insert({
        'name': name,
        'email': email,
        'phone': phone,
        'region': region,
        'qualification': qualification,
        'role': 'volunteer',
      });
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<List<AdminVolunteerEntity>> getVolunteers() async {
    try {
      const cacheKey = 'admin_volunteers';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map<AdminVolunteerEntity>((e) =>
                AdminVolunteerEntity.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }

      final data = await _client
          .from('users')
          .select(
            'id, name, avatar_url, rating, region, total_hours, total_tasks, is_online, last_seen_at, role',
          )
          .inFilter('role', ['volunteer', 'user'])
          .order('name');
      final volunteers = (data as List)
          .map((e) => AdminVolunteerEntity.fromJson(e as Map<String, dynamic>))
          .toList();

      await LocalAppStorage.setCache(
          cacheKey, data, ttl: const Duration(minutes: 5));
      return volunteers;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<VolunteerDetailsEntity> getVolunteerDetails(String volunteerId) async {
    try {
      final userRaw = await _client
          .from('users')
          .select('*')
          .eq('id', volunteerId)
          .single();
      final tasksRaw = await _client
          .from('task_assignments')
          .select('*, tasks(title, duration_hours)')
          .eq('user_id', volunteerId)
          .order('assigned_at', ascending: false);
      final tasks = tasksRaw
          .map(
            (e) => VolunteerTaskAssignmentEntity.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
      final areasRaw = await _client
          .from('task_assignments')
          .select('tasks!inner(type)')
          .eq('user_id', volunteerId);
      final volunteerAreas = (areasRaw as List)
          .map((e) => (e['tasks'] as Map<String, dynamic>)['type'] as String?)
          .whereType<String>()
          .toSet()
          .toList();
      return VolunteerDetailsEntity.fromJson(userRaw, tasks, volunteerAreas);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> deleteVolunteer(String volunteerId) async {
    try {
      // Delete related records first to satisfy foreign key constraints
      await _client.from('admin_notes').delete().eq('volunteer_id', volunteerId);
      await _client.from('assessments').delete().eq('volunteer_id', volunteerId);
      await _client.from('task_assignments').delete().eq('user_id', volunteerId);
      await _client.from('users').delete().eq('id', volunteerId);
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> approveVolunteer(String volunteerId) async {
    try {
      await _client
          .from('users')
          .update({'role': 'volunteer'}).eq('id', volunteerId);
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  // ── Volunteer Detail Actions ──

  @override
  Future<List<Map<String, dynamic>>> getAvailableTasks(
      String volunteerId) async {
    try {
      final assignedRaw = await _client
          .from('task_assignments')
          .select('task_id')
          .eq('user_id', volunteerId);
      final assignedIds =
          (assignedRaw as List).map((e) => e['task_id'] as String).toList();

      var query = _client
          .from('tasks')
          .select('id, title, date, type')
          .inFilter('status', ['upcoming', 'active']);

      if (assignedIds.isNotEmpty) {
        query = query.not('id', 'in', '(${assignedIds.join(",")})');
      }

      final data = await query.order('date');
      return (data as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> assignTask({
    required String volunteerId,
    required String taskId,
    required String adminId,
  }) async {
    try {
      await _client.from('task_assignments').insert({
        'task_id': taskId,
        'user_id': volunteerId,
        'assigned_by': adminId,
        'status': 'assigned',
        'assigned_at': DateTime.now().toUtc().toIso8601String(),
      });
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> sendDirectMessage({
    required String adminId,
    required String volunteerId,
    required String title,
    required String body,
  }) async {
    try {
      await _client.from('admin_notes').insert({
        'admin_id': adminId,
        'volunteer_id': volunteerId,
        'task_id': null,
        'title': title,
        'body': body,
        'is_read': false,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> addRating({
    required String adminId,
    required String volunteerId,
    required int rating,
    String? comment,
  }) async {
    try {
      await _client.from('assessments').insert({
        'admin_id': adminId,
        'volunteer_id': volunteerId,
        'task_id': null,
        'rating': rating,
        'comment': comment,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      // Recalculate average rating
      final assessments = await _client
          .from('assessments')
          .select('rating')
          .eq('volunteer_id', volunteerId);
      final ratings =
          (assessments as List).map((e) => (e['rating'] as num).toDouble());
      final avg = ratings.isEmpty
          ? 0.0
          : ratings.reduce((a, b) => a + b) / ratings.length;
      await _client
          .from('users')
          .update({'rating': avg}).eq('id', volunteerId);
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> upgradeLevel({
    required String volunteerId,
    required int level,
    required String levelTitle,
  }) async {
    try {
      await _client.from('users').update({
        'level': level,
      }).eq('id', volunteerId);
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> editVolunteerData({
    required String volunteerId,
    required Map<String, dynamic> fields,
  }) async {
    try {
      await _client.from('users').update(fields).eq('id', volunteerId);
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> assignCustomTask({
    required String volunteerId,
    required String adminId,
    required String title,
    required String type,
    String? description,
    required String locationName,
    String? locationAddress,
    required String date,
    required String timeStart,
    required String timeEnd,
    required double durationHours,
    required int points,
    String? supervisorName,
    String? supervisorPhone,
    String? notes,
  }) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final response = await _client
          .from('tasks')
          .insert({
            'title': title,
            'type': type,
            if (description != null && description.isNotEmpty)
              'description': description,
            'status': 'upcoming',
            'date': date,
            'time_start': timeStart,
            'time_end': timeEnd,
            'duration_hours': durationHours,
            'points': points,
            'location_name': locationName,
            if (locationAddress != null && locationAddress.isNotEmpty)
              'location_address': locationAddress,
            if (supervisorName != null && supervisorName.isNotEmpty)
              'supervisor_name': supervisorName,
            if (supervisorPhone != null && supervisorPhone.isNotEmpty)
              'supervisor_phone': supervisorPhone,
            if (notes != null && notes.isNotEmpty) 'notes': notes,
            'target_beneficiaries': 0,
            'reached_beneficiaries': 0,
            'created_by': adminId,
          })
          .select('id')
          .single();
      final taskId = response['id'] as String;
      await _client.from('task_assignments').insert({
        'task_id': taskId,
        'user_id': volunteerId,
        'assigned_by': adminId,
        'status': 'assigned',
        'assigned_at': now,
      });
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> suspendAccount(String volunteerId) async {
    try {
      await _client
          .from('users')
          .update({'role': 'suspended'}).eq('id', volunteerId);
      await LocalAppStorage.invalidateCache('admin_volunteers');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
