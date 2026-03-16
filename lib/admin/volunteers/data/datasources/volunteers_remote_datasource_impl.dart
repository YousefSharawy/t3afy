import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/admin/volunteers/data/datasources/volunteers_remote_datasource.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';

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
  Future<List<AdminVolunteerEntity>> getVolunteers() async {
    try {
      final data = await _client
          .from('users')
          .select(
            'id, name, avatar_url, rating, region, total_hours, total_tasks, is_online, last_seen_at, role',
          )
          .inFilter('role', ['volunteer', 'user'])
          .order('name');
      return (data as List)
          .map((e) => AdminVolunteerEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
