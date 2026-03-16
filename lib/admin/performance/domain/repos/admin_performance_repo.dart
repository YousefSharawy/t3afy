import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';

abstract class AdminPerformanceRepo {
  Future<Either<Failture, AdminPerformanceEntity>> getPerformanceData();
}
