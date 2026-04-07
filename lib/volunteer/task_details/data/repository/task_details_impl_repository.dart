import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/app/local_storage.dart';

import '../../domain/entities/task_details_entity.dart';
import '../../domain/repository/task_details_repository.dart';
import '../mappers/task_details_mapper.dart';
import '../sources/check_in_data_source.dart';
import '../sources/task_details_remote_data_source.dart';

class TaskDetailsImplRepository implements TaskDetailsRepository {
  final TaskDetailsRemoteDataSource _dataSource;
  final CheckInDataSource? _checkInDataSource;

  TaskDetailsImplRepository(
    this._dataSource, {
    CheckInDataSource? checkInDataSource,
  }) : _checkInDataSource = checkInDataSource;

  @override
  Future<Either<Failture, TaskDetailsEntity>> getTaskDetails(
    String taskId,
  ) async {
    try {
      final taskModel = await _dataSource.getTaskDetails(taskId);
      final objectiveModels = await _dataSource.getTaskObjectives(taskId);
      final supplyModels = await _dataSource.getTaskSupplies(taskId);
      final papers = await _dataSource.getTaskPapers(taskId);

      final objectives = objectiveModels.map((m) => m.toEntity()).toList();
      final supplies = supplyModels.map((m) => m.toEntity()).toList();

      // Fetch check-in/out data if available
      DateTime? checkedInAt;
      DateTime? checkedOutAt;
      double? verifiedHours;
      bool isVerified = false;
      if (_checkInDataSource != null) {
        try {
          final userId = LocalAppStorage.getUserId() ?? '';
          final status = await _checkInDataSource.getCheckInStatus(
            taskId,
            userId,
          );
          if (status != null) {
            final inStr = status['checked_in_at'] as String?;
            final outStr = status['checked_out_at'] as String?;
            if (inStr != null) checkedInAt = DateTime.tryParse(inStr);
            if (outStr != null) checkedOutAt = DateTime.tryParse(outStr);
            verifiedHours = ((status['verified_hours'] as num?) ?? 0)
                .toDouble();
            isVerified = (status['is_verified'] as bool?) ?? false;
          }
        } catch (_) {}
      }

      return Right(
        taskModel.toEntity(
          objectives,
          supplies,
          papers: papers,
          checkedInAt: checkedInAt,
          checkedOutAt: checkedOutAt,
          verifiedHours: verifiedHours,
          isVerified: isVerified,
        ),
      );
    } on Failture catch (failture) {
      return Left(failture);
    }
  }
}
