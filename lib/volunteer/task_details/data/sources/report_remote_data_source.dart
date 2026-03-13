import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';

abstract class ReportRemoteDataSource {
  Future<void> submitReport(TaskReportModel model);
}
