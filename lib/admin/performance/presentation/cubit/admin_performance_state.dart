import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';

abstract class AdminPerformanceState {}

class AdminPerformanceInitial extends AdminPerformanceState {}

class AdminPerformanceLoading extends AdminPerformanceState {
  final String selectedPeriod;
  AdminPerformanceLoading({this.selectedPeriod = 'year'});
}

class AdminPerformanceLoaded extends AdminPerformanceState {
  final AdminPerformanceEntity data;
  final String selectedPeriod;
  AdminPerformanceLoaded(this.data, {this.selectedPeriod = 'year'});
}

class AdminPerformanceError extends AdminPerformanceState {
  final String message;
  final String selectedPeriod;
  AdminPerformanceError(this.message, {this.selectedPeriod = 'year'});
}
