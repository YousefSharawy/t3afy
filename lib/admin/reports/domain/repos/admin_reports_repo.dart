import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

abstract class AdminReportsRepo {
  Future<Either<Failture, List<AdminReportEntity>>> getReports();
  Future<Either<Failture, void>> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
    required String adminId,
  });
  void subscribeRealtime(void Function() onChanged);
  void disposeRealtime();
}
