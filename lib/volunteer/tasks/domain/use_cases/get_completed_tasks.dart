import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/domain/repository/tasks_repository.dart';

class GetCompletedTasks {
  final TasksRepository _repository;
  GetCompletedTasks(this._repository);

  Future<Either<Failture, List<TaskEntity>>> call(String userId) {
    return _repository.getCompletedTasks(userId);
  }
}
