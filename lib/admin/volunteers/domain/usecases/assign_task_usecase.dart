import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class AssignTaskUsecase {
  final VolunteersRepo _repo;

  AssignTaskUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String volunteerId,
    required String taskId,
    required String adminId,
  }) {
    return _repo.assignTask(
      volunteerId: volunteerId,
      taskId: taskId,
      adminId: adminId,
    );
  }
}
