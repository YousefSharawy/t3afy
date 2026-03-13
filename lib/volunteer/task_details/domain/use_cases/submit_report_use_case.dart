import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/domain/repository/report_repository.dart';

class SubmitReportUseCase {
  final ReportRepository _repo;

  SubmitReportUseCase(this._repo);

  Future<Either<Failture, void>> call(TaskReportModel model) =>
      _repo.submitReport(model);
}
