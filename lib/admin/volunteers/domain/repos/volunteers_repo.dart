import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

abstract class VolunteersRepo {
  Future<Either<Failture, List<AdminVolunteerEntity>>> getVolunteers();
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
}
