import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';

abstract class AdminPerformanceState {}

class AdminPerformanceInitial extends AdminPerformanceState {}

class AdminPerformanceLoading extends AdminPerformanceState {}

class AdminPerformanceLoaded extends AdminPerformanceState {
  final AdminPerformanceEntity data;
  AdminPerformanceLoaded(this.data);
}

class AdminPerformanceError extends AdminPerformanceState {
  final String message;
  AdminPerformanceError(this.message);
}
