import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class AssignCustomTaskUsecase {
  final VolunteersRepo _repo;

  AssignCustomTaskUsecase(this._repo);

  Future<Either<Failture, void>> call({
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
  }) {
    return _repo.assignCustomTask(
      volunteerId: volunteerId,
      adminId: adminId,
      title: title,
      type: type,
      description: description,
      locationName: locationName,
      locationAddress: locationAddress,
      date: date,
      timeStart: timeStart,
      timeEnd: timeEnd,
      durationHours: durationHours,
      points: points,
      supervisorName: supervisorName,
      supervisorPhone: supervisorPhone,
      notes: notes,
    );
  }
}
