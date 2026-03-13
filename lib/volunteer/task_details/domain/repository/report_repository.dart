import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';

abstract class ReportRepository {
  Future<Either<Failture, void>> submitReport(TaskReportModel model);
}
