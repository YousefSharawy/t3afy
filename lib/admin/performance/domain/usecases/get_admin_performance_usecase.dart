import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/admin/performance/domain/repos/admin_performance_repo.dart';

class GetAdminPerformanceUsecase {
  final AdminPerformanceRepo _repo;

  GetAdminPerformanceUsecase(this._repo);

  Future<Either<Failture, AdminPerformanceEntity>> call() {
    return _repo.getPerformanceData();
  }
}
