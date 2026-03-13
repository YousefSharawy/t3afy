import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';

import '../../domain/entities/task_details_entity.dart';
import '../../domain/repository/task_details_repository.dart';
import '../mappers/task_details_mapper.dart';
import '../sources/task_details_remote_data_source.dart';

class TaskDetailsImplRepository implements TaskDetailsRepository {
  final TaskDetailsRemoteDataSource _dataSource;

  TaskDetailsImplRepository(this._dataSource);

  @override
  Future<Either<Failture, TaskDetailsEntity>> getTaskDetails(
    String taskId,
  ) async {
    try {
      final taskModel = await _dataSource.getTaskDetails(taskId);
      final objectiveModels = await _dataSource.getTaskObjectives(taskId);
      final supplyModels = await _dataSource.getTaskSupplies(taskId);

      final objectives = objectiveModels.map((m) => m.toEntity()).toList();
      final supplies = supplyModels.map((m) => m.toEntity()).toList();

      return Right(taskModel.toEntity(objectives, supplies));
    } on Failture catch (failture) {
      return Left(failture);
    }
  }
}
