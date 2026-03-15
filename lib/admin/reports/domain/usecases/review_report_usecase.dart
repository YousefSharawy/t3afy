import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';

class ReviewReportUsecase {
  final AdminReportsRepo _repo;

  ReviewReportUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String reportId,
    required String status,
    String? feedback,
    required String adminId,
  }) {
    return _repo.reviewReport(
      reportId: reportId,
      status: status,
      feedback: feedback,
      adminId: adminId,
    );
  }
}
