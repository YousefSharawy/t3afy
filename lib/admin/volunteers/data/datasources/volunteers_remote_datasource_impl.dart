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
          .select('*, tasks(*)')
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
}
