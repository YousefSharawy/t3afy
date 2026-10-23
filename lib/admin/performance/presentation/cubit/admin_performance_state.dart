import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';

abstract class AdminPerformanceState {}

class AdminPerformanceInitial extends AdminPerformanceState {}

class AdminPerformanceLoading extends AdminPerformanceState {
  final String selectedPeriod;
  AdminPerformanceLoading({this.selectedPeriod = 'year'});
}

class AdminPerformanceLoaded extends AdminPerformanceState {
  final AdminPerformanceEntity data;

  /// The period [data] belongs to (the chip may already show the next one).
  final String selectedPeriod;

  /// True while another period is being fetched; [data] stays on screen.
  final bool isRefreshing;
  AdminPerformanceLoaded(
    this.data, {
    this.selectedPeriod = 'year',
    this.isRefreshing = false,
  });
}

class AdminPerformanceError extends AdminPerformanceState {
  final String message;
  final String selectedPeriod;
  AdminPerformanceError(this.message, {this.selectedPeriod = 'year'});
}
