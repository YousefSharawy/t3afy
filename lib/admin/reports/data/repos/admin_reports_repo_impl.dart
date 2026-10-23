import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';
import 'package:t3afy/core/data/realtime_hub.dart';

class AdminReportsRepoImpl implements AdminReportsRepo {
  final AdminReportsRemoteDatasource _datasource;
  RealtimeHub? _hub;

  AdminReportsRepoImpl(this._datasource);

  @override
  Future<Either<Failture, List<AdminReportEntity>>> getReports() async {
    try {
      final list = await _datasource.getReports();
      return Right(list);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
    required String adminId,
  }) async {
    try {
      await _datasource.reviewReport(
        reportId: reportId,
        status: status,
        feedback: feedback,
        adminId: adminId,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  void subscribeRealtime(
    void Function() onChanged, {
    bool Function(String? reportId)? ignore,
  }) {
    _hub?.dispose();
    _hub = RealtimeHub()
      ..watch(
        name: 'task_reports_admin',
        table: 'task_reports',
        onChange: onChanged,
        ignore: ignore == null
            ? null
            : (p) => ignore(
                (p.newRecord['id'] ?? p.oldRecord['id'])?.toString(),
              ),
      );
  }

  @override
  void disposeRealtime() {
    _hub?.dispose();
    _hub = null;
  }
}
