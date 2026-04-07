import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

abstract class TasksRepository {
  Future<Either<Failture, List<TaskEntity>>> getTodayTasks(String userId, {bool skipCache = false});
  Future<Either<Failture, List<TaskEntity>>> getCompletedTasks(String userId, {bool skipCache = false});
  Future<Either<Failture, TasksStatsEntity>> getTasksStats(String userId, {bool skipCache = false});
}
