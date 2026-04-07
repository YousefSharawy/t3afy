import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/domain/repository/tasks_repository.dart';

class GetTodayTasks {
  final TasksRepository _repository;
  GetTodayTasks(this._repository);

  Future<Either<Failture, List<TaskEntity>>> call(String userId, {bool skipCache = false}) {
    return _repository.getTodayTasks(userId, skipCache: skipCache);
  }
}
