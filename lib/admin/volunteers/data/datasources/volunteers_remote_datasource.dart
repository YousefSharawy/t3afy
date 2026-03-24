import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

abstract class VolunteersRemoteDatasource {
  Future<List<AdminVolunteerEntity>> getVolunteers();
  Future<List<AdminVolunteerEntity>> getPendingUsers();
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
  Future<void> approveVolunteer(String volunteerId);

  // ── Volunteer Detail Actions ──
  Future<List<Map<String, dynamic>>> getAvailableTasks(String volunteerId);
  Future<void> assignTask({
    required String volunteerId,
    required String taskId,
    required String adminId,
  });
  Future<void> sendDirectMessage({
    required String adminId,
    required String volunteerId,
    required String title,
    required String body,
  });
  Future<void> addRating({
    required String adminId,
    required String volunteerId,
    required int rating,
    String? comment,
  });
  Future<void> upgradeLevel({
    required String volunteerId,
    required int level,
    required String levelTitle,
  });
  Future<void> editVolunteerData({
    required String volunteerId,
    required Map<String, dynamic> fields,
  });
  Future<void> suspendAccount(String volunteerId);
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
  });
}
