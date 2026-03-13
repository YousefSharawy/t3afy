import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/data/sources/report_remote_data_source.dart';

class ReportImplRemoteDataSource implements ReportRemoteDataSource {
  @override
  Future<void> submitReport(TaskReportModel model) async {
    try {
      await Supabase.instance.client
          .from('task_reports')
          .insert(model.toJson());
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
