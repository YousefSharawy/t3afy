import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/domain/repository/tasks_repository.dart';

class GetTasksStats {
  final TasksRepository _repository;
  GetTasksStats(this._repository);

  Future<Either<Failture, TasksStatsEntity>> call(String userId) {
    return _repository.getTasksStats(userId);
  }
}
