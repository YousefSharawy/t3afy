import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';

class AdminReportsRepoImpl implements AdminReportsRepo {
  final AdminReportsRemoteDatasource _datasource;
  RealtimeChannel? _channel;

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
  void subscribeRealtime(void Function() onChanged) {
    _channel = _datasource.subscribeRealtime(onChanged);
  }

  @override
  void disposeRealtime() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
  }
}
