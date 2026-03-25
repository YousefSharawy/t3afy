import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/home/data/sources/volunteer_home_remote_data_source.dart';
import 'package:t3afy/volunteer/home/domain/repository/home_repository.dart';
import 'package:t3afy/volunteer/home/data/mappers/home_mappers.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class HomeImplRepository implements VolunteerHomeRepository {
  final VolunteerHomeRemoteDataSource _dataSource;

  HomeImplRepository(this._dataSource);

  @override
  Future<Either<Failture, VolunteerStatsEntity>> getVolunteerStats(
    String userId,
  ) async {
    try {
      final result = await _dataSource.getVolunteerStats(userId);
      return Right(result.toEntity());
    } on Failture catch (failture) {
      return Left(failture);
    }
  }

  @override
  Future<Either<Failture, List<TaskEntity>>> getTodayTasks(
    String userId,
  ) async {
    try {
      final result = await _dataSource.getTodayTasks(userId);
      return Right(result.map((t) => t.toEntity()).toList());
    } on Failture catch (failture) {
      return Left(failture);
    }
  }

  @override
  Future<Either<Failture, int>> getUnreadNotificationsCount(
    String userId,
  ) async {
    try {
      final result = await _dataSource.getUnreadNotificationsCount(userId);
      return Right(result);
    } on Failture catch (failture) {
      return Left(failture);
    }
  }
}
