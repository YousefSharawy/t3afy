import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/admin/performance/domain/usecases/get_admin_performance_usecase.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

class AdminPerformanceCubit extends Cubit<AdminPerformanceState>
    with SafeEmit<AdminPerformanceState> {
  final GetAdminPerformanceUsecase _usecase;

  /// Period the chips show (set immediately on tap; data follows).
  String _currentPeriod = 'year';
  String get currentPeriod => _currentPeriod;

  final Map<String, AdminPerformanceEntity> _cache = {};

  // Every check-in / status change anywhere fires these tables, so coalesce
  // bursts (aggregate screen), but still refresh within ~1 s of an event.
  final RealtimeHub _hub = RealtimeHub(
    debounce: const Duration(milliseconds: 600),
    maxWait: const Duration(milliseconds: 1200),
    fallbackPoll: const Duration(seconds: 60),
  );

  bool _visible = true;
  bool _staleWhileHidden = false;

  AdminPerformanceCubit(this._usecase) : super(AdminPerformanceInitial()) {
    loadPerformance('year');
    _hub
      ..watch(
        name: 'admin_performance_tasks',
        table: 'tasks',
        onChange: _onRealtimeChange,
      )
      ..watch(
        name: 'admin_performance_assignments',
        table: 'task_assignments',
        onChange: _onRealtimeChange,
      );
  }

  /// Called by the view when its tab becomes visible / hidden. Realtime
  /// changes while hidden are applied once on return instead of refetching.
  void setVisible(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    if (visible && _staleWhileHidden) {
      _staleWhileHidden = false;
      _silentRefresh();
    }
  }

  void _onRealtimeChange() {
    if (!_visible) {
      _staleWhileHidden = true;
      return;
    }
    _silentRefresh();
  }

  void _silentRefresh() {
    _cache.clear();
    loadPerformance(_currentPeriod, forceRefresh: true);
  }

  /// Pull-to-refresh: bypasses both the in-memory and the Hive cache.
  /// Returns the error message (null on success).
  Future<String?> refresh() {
    _cache.clear();
    return loadPerformance(_currentPeriod, forceRefresh: true);
  }

  @override
  Future<void> close() async {
    await _hub.dispose();
    return super.close();
  }

  /// Loads [period]. With data already on screen it never emits a loading
  /// state: the previous data stays (with a refreshing bar when switching
  /// period) and a failure keeps it. Returns the error message, or null.
  Future<String?> loadPerformance(
    String period, {
    bool forceRefresh = false,
  }) async {
    _currentPeriod = period;

    if (forceRefresh) _cache.remove(period);

    final cached = _cache[period];
    if (cached != null) {
      emit(AdminPerformanceLoaded(cached, selectedPeriod: period));
      return null;
    }

    final s = state;
    final previous = s is AdminPerformanceLoaded ? s : null;
    if (previous != null) {
      emit(
        AdminPerformanceLoaded(
          previous.data,
          selectedPeriod: previous.selectedPeriod,
          isRefreshing: previous.selectedPeriod != period,
        ),
      );
    } else {
      emit(AdminPerformanceLoading(selectedPeriod: period));
    }

    final result = await _usecase(period, forceRefresh: forceRefresh);
    return result.fold(
      (f) {
        if (_currentPeriod != period) return f.message;
        if (previous != null) {
          _currentPeriod = previous.selectedPeriod;
          safeEmit(
            AdminPerformanceLoaded(
              previous.data,
              selectedPeriod: previous.selectedPeriod,
            ),
          );
        } else {
          safeEmit(AdminPerformanceError(f.message, selectedPeriod: period));
        }
        return f.message;
      },
      (data) {
        _cache[period] = data;
        // The user already switched to another period: keep this result
        // cached but don't show it.
        if (_currentPeriod != period) return null;
        safeEmit(AdminPerformanceLoaded(data, selectedPeriod: period));
        return null;
      },
    );
  }
}
