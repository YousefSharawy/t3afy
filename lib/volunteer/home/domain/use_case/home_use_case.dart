import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/home/domain/repository/home_repository.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class GetVolunteerStats {
  final VolunteerHomeRepository _repository;

  GetVolunteerStats(this._repository);

  Future<Either<Failture, VolunteerStatsEntity>> call(
    String userId, {
    bool skipCache = false,
  }) {
    return _repository.getVolunteerStats(userId, skipCache: skipCache);
  }
}

class GetHomeTodayTasks {
  final VolunteerHomeRepository _repository;

  GetHomeTodayTasks(this._repository);

  Future<Either<Failture, List<TaskEntity>>> call(
    String userId, {
    bool skipCache = false,
  }) {
    return _repository.getTodayTasks(userId, skipCache: skipCache);
  }
}

/// No longer used by Home (the nav shell's bell owns the live unread badge).
/// Kept only because di.dart still registers it.
class GetUnreadNotificationsCount {
  final VolunteerHomeRepository _repository;

  GetUnreadNotificationsCount(this._repository);

  Future<Either<Failture, int>> call(String userId) {
    return _repository.getUnreadNotificationsCount(userId);
  }
}
