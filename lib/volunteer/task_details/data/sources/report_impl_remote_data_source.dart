import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/data/sources/report_remote_data_source.dart';

class ReportImplRemoteDataSource implements ReportRemoteDataSource {
  @override
  Future<void> submitReport(TaskReportModel model) async {
    try {
      final client = Supabase.instance.client;
      final existing = await client
          .from('task_reports')
          .select('id')
          .eq('task_id', model.taskId)
          .eq('user_id', model.userId)
          .maybeSingle();
      if (existing != null) {
        throw const PostgrestException(
          message: 'لقد قمت برفع تقرير لهذه المهمة من قبل',
          code: '23505',
        );
      }
      await client.from('task_reports').insert(model.toJson());
      // Mark assignment as pending_review — credit is granted only after
      // admin approves the report.
      await client
          .from('task_assignments')
          .update({'status': 'pending_review'})
          .eq('task_id', model.taskId)
          .eq('user_id', model.userId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<Map<String, dynamic>?> getExistingReport(
    String taskId,
    String userId,
  ) async {
    try {
      return await Supabase.instance.client
          .from('task_reports')
          .select()
          .eq('task_id', taskId)
          .eq('user_id', userId)
          .maybeSingle();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
