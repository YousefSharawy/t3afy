import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';

abstract class AdminPerformanceRemoteDatasource {
  Future<AdminPerformanceEntity> getPerformanceData(
    DateTime startDate,
    String period,
  );
}
