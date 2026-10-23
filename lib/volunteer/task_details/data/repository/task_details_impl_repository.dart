import 'package:dartz/dartz.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';
import 'package:t3afy/app/failture.dart';

import '../../domain/entities/task_details_entity.dart';
import '../../domain/repository/task_details_repository.dart';
import '../mappers/task_details_mapper.dart';
import '../models/task_objective_model.dart';
import '../models/task_supply_model.dart';
import '../sources/check_in_data_source.dart';
import '../sources/task_details_remote_data_source.dart';

class TaskDetailsImplRepository implements TaskDetailsRepository {
  final TaskDetailsRemoteDataSource _dataSource;

  /// [checkInDataSource] is accepted for the DI signature only: the check-in
  /// columns now arrive embedded in the task query (one round trip less).
  TaskDetailsImplRepository(
    this._dataSource, {
    CheckInDataSource? checkInDataSource,
  });

  @override
  Future<Either<Failture, TaskDetailsEntity>> getTaskDetails(
    String taskId,
  ) async {
    try {
      final results = await Future.wait<Object>([
        _dataSource.getTaskDetails(taskId),
        _dataSource.getTaskObjectives(taskId),
        _dataSource.getTaskSupplies(taskId),
        _dataSource.getTaskPapers(taskId),
      ]);
      final taskResult = results[0] as TaskWithAssignment;
      final objectives = (results[1] as List<TaskObjectiveModel>)
          .map((m) => m.toEntity())
          .toList();
      final supplies = (results[2] as List<TaskSupplyModel>)
          .map((m) => m.toEntity())
          .toList();
      final papers = results[3] as List<CampaignPaperEntity>;

      final a = taskResult.assignment;
      final inStr = a?['checked_in_at'] as String?;
      final outStr = a?['checked_out_at'] as String?;

      return Right(
        taskResult.task.toEntity(
          objectives,
          supplies,
          papers: papers,
          checkedInAt: inStr != null ? DateTime.tryParse(inStr) : null,
          checkedOutAt: outStr != null ? DateTime.tryParse(outStr) : null,
          verifiedHours: a == null
              ? null
              : ((a['verified_hours'] as num?) ?? 0).toDouble(),
          isVerified: (a?['is_verified'] as bool?) ?? false,
        ),
      );
    } on Failture catch (failture) {
      return Left(failture);
    }
  }
}
