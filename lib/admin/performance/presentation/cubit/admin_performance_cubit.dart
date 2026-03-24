import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/admin/performance/domain/usecases/get_admin_performance_usecase.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';

class AdminPerformanceCubit extends Cubit<AdminPerformanceState> {
  final GetAdminPerformanceUsecase _usecase;

  String _currentPeriod = 'year';
  String get currentPeriod => _currentPeriod;

  final Map<String, AdminPerformanceEntity> _cache = {};

  RealtimeChannel? _tasksChannel;
  RealtimeChannel? _assignmentsChannel;
  Timer? _debounce;

  AdminPerformanceCubit(this._usecase) : super(AdminPerformanceInitial()) {
    loadPerformance('year');
    _subscribeToRealtime();
  }

  void _subscribeToRealtime() {
    _tasksChannel = Supabase.instance.client
        .channel('admin_performance_tasks')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();

    _assignmentsChannel = Supabase.instance.client
        .channel('admin_performance_assignments')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_assignments',
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();
  }

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _cache.remove(_currentPeriod);
      loadPerformance(_currentPeriod);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _tasksChannel?.unsubscribe();
    await _assignmentsChannel?.unsubscribe();
    return super.close();
  }

  Future<void> loadPerformance(String period, {bool forceRefresh = false}) async {
    _currentPeriod = period;

    if (forceRefresh) {
      _cache.remove(period);
    }

    final cached = _cache[period];
    if (cached != null) {
      emit(AdminPerformanceLoaded(cached, selectedPeriod: period));
      return;
    }

    emit(AdminPerformanceLoading(selectedPeriod: period));
    final result = await _usecase(period);
    result.fold(
      (f) => emit(AdminPerformanceError(f.message, selectedPeriod: period)),
      (data) {
        _cache[period] = data;
        emit(AdminPerformanceLoaded(data, selectedPeriod: period));
      },
    );
  }
}
