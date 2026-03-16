import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';

abstract class VolunteersRemoteDatasource {
  Future<List<AdminVolunteerEntity>> getVolunteers();
  RealtimeChannel subscribeOnlineStatus(void Function() onChanged);
}
