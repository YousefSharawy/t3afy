import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

abstract class VolunteersRepo {
  Future<Either<Failture, List<AdminVolunteerEntity>>> getVolunteers();
  Future<Either<Failture, List<AdminVolunteerEntity>>> getPendingUsers();
  void subscribeRealtime(void Function() onChanged);
  void disposeRealtime();
  Future<Either<Failture, void>> addVolunteer({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  });
  Future<Either<Failture, VolunteerDetailsEntity>> getVolunteerDetails(
    String volunteerId,
  );
  Future<Either<Failture, void>> deleteVolunteer(String volunteerId);
  Future<Either<Failture, void>> approveVolunteer(String volunteerId);

  // ── Volunteer Detail Actions ──
  Future<Either<Failture, List<Map<String, dynamic>>>> getAvailableTasks(
      String volunteerId);
  Future<Either<Failture, void>> assignTask({
    required String volunteerId,
    required String taskId,
    required String adminId,
  });
  Future<Either<Failture, void>> sendDirectMessage({
    required String adminId,
    required String volunteerId,
    required String title,
    required String body,
  });
  Future<Either<Failture, void>> addRating({
    required String adminId,
    required String volunteerId,
    required int rating,
    String? comment,
  });
  Future<Either<Failture, void>> upgradeLevel({
    required String volunteerId,
    required int level,
    required String levelTitle,
  });
  Future<Either<Failture, void>> editVolunteerData({
    required String volunteerId,
    required Map<String, dynamic> fields,
  });
  Future<Either<Failture, void>> suspendAccount(String volunteerId);
  Future<Either<Failture, void>> assignCustomTask({
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
