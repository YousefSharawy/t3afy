import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/data/sources/report_remote_data_source.dart';
import 'package:t3afy/volunteer/task_details/domain/repository/report_repository.dart';

class ReportImplRepository implements ReportRepository {
  final ReportRemoteDataSource _dataSource;

  ReportImplRepository(this._dataSource);

  @override
  Future<Either<Failture, void>> submitReport(TaskReportModel model) async {
    try {
      await _dataSource.submitReport(model);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
