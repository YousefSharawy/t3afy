import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';

import '../entities/task_details_entity.dart';
import '../repository/task_details_repository.dart';

class GetTaskDetailsUseCase {
  final TaskDetailsRepository _repository;

  GetTaskDetailsUseCase(this._repository);

  Future<Either<Failture, TaskDetailsEntity>> call(String taskId) {
    return _repository.getTaskDetails(taskId);
  }
}
