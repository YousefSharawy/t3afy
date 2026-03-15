import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

class AdminReportsRemoteDatasourceImpl
    implements AdminReportsRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<List<AdminReportEntity>> getReports() async {
    try {
      final data = await _client
          .from('task_reports')
          .select(
              '*, tasks(title), users!task_reports_user_id_fkey(name)')
          .order('created_at', ascending: false);
      return (data as List)
          .map((e) => AdminReportEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
    required String adminId,
  }) async {
    try {
      await _client.from('task_reports').update({
        'status': status,
        'admin_feedback': feedback,
        'reviewed_by': adminId,
        'reviewed_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', reportId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  RealtimeChannel subscribeRealtime(void Function() onChanged) {
    return _client
        .channel('task_reports_admin')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_reports',
          callback: (_) => onChanged(),
        )
        .subscribe();
  }
}
