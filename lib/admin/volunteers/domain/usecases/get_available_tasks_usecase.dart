import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class GetAvailableTasksUsecase {
  final VolunteersRepo _repo;

  GetAvailableTasksUsecase(this._repo);

  Future<Either<Failture, List<Map<String, dynamic>>>> call(
    String volunteerId,
  ) {
    return _repo.getAvailableTasks(volunteerId);
  }
}
