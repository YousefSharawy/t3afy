import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/admin/performance/domain/repos/admin_performance_repo.dart';

class GetAdminPerformanceUsecase {
  final AdminPerformanceRepo _repo;

  GetAdminPerformanceUsecase(this._repo);

  Future<Either<Failture, AdminPerformanceEntity>> call(String period) {
    final startDate = _startDateFor(period);
    return _repo.getPerformanceData(startDate, period);
  }

  DateTime _startDateFor(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'week':
        return now.subtract(const Duration(days: 7));
      case 'months':
        return now.subtract(const Duration(days: 30));
      default:
        return now.subtract(const Duration(days: 365));
    }
  }
}
