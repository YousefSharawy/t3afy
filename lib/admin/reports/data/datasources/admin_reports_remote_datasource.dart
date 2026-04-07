import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

abstract class AdminReportsRemoteDatasource {
  Future<List<AdminReportEntity>> getReports();
  Future<void> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
    required String adminId,
  });
  RealtimeChannel subscribeRealtime(void Function() onChanged);
}
