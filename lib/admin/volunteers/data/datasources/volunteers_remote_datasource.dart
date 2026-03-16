import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

abstract class VolunteersRemoteDatasource {
  Future<List<AdminVolunteerEntity>> getVolunteers();
  RealtimeChannel subscribeOnlineStatus(void Function() onChanged);
  Future<void> addVolunteer({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  });
  Future<VolunteerDetailsEntity> getVolunteerDetails(String volunteerId);
  Future<void> deleteVolunteer(String volunteerId);
}
