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

  /// [ignore] receives the changed report id; return true to drop the event
  /// (used for echoes of the manager's own review).
  void subscribeRealtime(
    void Function() onChanged, {
    bool Function(String? reportId)? ignore,
  });
  void disposeRealtime();
}
