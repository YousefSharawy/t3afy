import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';

class GetReportsUsecase {
  final AdminReportsRepo _repo;

  GetReportsUsecase(this._repo);

  Future<Either<Failture, List<AdminReportEntity>>> call() {
    return _repo.getReports();
  }
}
