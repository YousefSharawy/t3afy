import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/home/domain/repository/home_repository.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class GetVolunteerStats {
  final VolunteerHomeRepository _repository;

  GetVolunteerStats(this._repository);

  Future<Either<Failture, VolunteerStatsEntity>> call(String userId) {
    return _repository.getVolunteerStats(userId);
  }
}

class GetTodayTasks {
  final VolunteerHomeRepository _repository;

  GetTodayTasks(this._repository);

  Future<Either<Failture, List<TaskEntity>>> call(String userId) {
    return _repository.getTodayTasks(userId);
  }
}
