import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/task_details/domain/repository/report_repository.dart';

class GetExistingReportUseCase {
  final ReportRepository _repo;

  GetExistingReportUseCase(this._repo);

  Future<Either<Failture, Map<String, dynamic>?>> call(
    String taskId,
    String userId,
  ) => _repo.getExistingReport(taskId, userId);
}
