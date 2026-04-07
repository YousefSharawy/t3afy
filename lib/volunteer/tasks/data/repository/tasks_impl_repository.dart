import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/home/data/mappers/home_mappers.dart';
import 'package:t3afy/volunteer/tasks/data/sources/tasks_remote_data_source.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/domain/repository/tasks_repository.dart';

class TasksImplRepository implements TasksRepository {
  final TasksRemoteDataSource _dataSource;

  TasksImplRepository(this._dataSource);

  @override
  Future<Either<Failture, List<TaskEntity>>> getTodayTasks(
    String userId, {bool skipCache = false}
  ) async {
    try {
      final models = await _dataSource.getTodayTasks(userId, skipCache: skipCache);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, List<TaskEntity>>> getCompletedTasks(
    String userId, {bool skipCache = false}
  ) async {
    try {
      final models = await _dataSource.getCompletedTasks(userId, skipCache: skipCache);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, TasksStatsEntity>> getTasksStats(
    String userId, {bool skipCache = false}
  ) async {
    try {
      final model = await _dataSource.getTasksStats(userId, skipCache: skipCache);
      return Right(model.toEntity());
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
