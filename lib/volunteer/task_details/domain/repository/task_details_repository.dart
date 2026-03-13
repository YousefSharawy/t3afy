import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';

import '../entities/task_details_entity.dart';

abstract class TaskDetailsRepository {
  Future<Either<Failture, TaskDetailsEntity>> getTaskDetails(String taskId);
}
