import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/volunteer/performance/domain/use_cases/performance_use_cases.dart';

part 'performance_state.dart';
part 'performance_cubit.freezed.dart';

class PerformanceCubit extends Cubit<PerformanceState>
    with SafeEmit<PerformanceState> {
  PerformanceCubit(
    this._getPerformanceStats,
    this._getMonthlyHours,
    this._getLeaderboard,
  ) : super(const PerformanceState.initial());

  final GetPerformanceStats _getPerformanceStats;
  final GetMonthlyHours _getMonthlyHours;
  final GetLeaderboard _getLeaderboard;

  RealtimeHub? _hub;
  String? _currentUserId;

  bool get _hasData =>
      state.maybeWhen(loaded: (_, _, _, _) => true, orElse: () => false);

  void _subscribeToRealtime(String userId) {
    _hub?.dispose();
    final hub = _hub = RealtimeHub();
    hub.watch(
      name: 'volunteer_performance_user_$userId',
      table: 'users',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: userId,
      ),
      onChange: _onRealtimeChange,
    );
    hub.watch(
      name: 'volunteer_performance_assignments_$userId',
      table: 'task_assignments',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      onChange: _onRealtimeChange,
    );
  }

  Future<void> _onRealtimeChange() async {
    if (_currentUserId == null || isClosed) return;
    await _invalidate(_currentUserId!);
    await loadPerformance(_currentUserId!);
  }

  Future<void> _invalidate(String userId) => Future.wait([
    LocalAppStorage.invalidateCache('perf_stats_$userId'),
    LocalAppStorage.invalidateCache('monthly_hours_$userId'),
    LocalAppStorage.invalidateCache('leaderboard_v2'),
  ]);

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }

  /// Pull-to-refresh: bypasses the cache and keeps the current data on screen.
  /// Returns an error message when the refresh failed (data is kept).
  Future<String?> refreshPerformance() async {
    final userId = _currentUserId;
    if (userId == null) return null;
    await _invalidate(userId);
    return loadPerformance(userId);
  }

  /// First load shows the loading state; later loads swap data in place and
  /// never replace good data with an error. Returns the error message, if any.
  Future<String?> loadPerformance(String userId) async {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      _subscribeToRealtime(userId);
    }
    final hadData = _hasData;
    if (!hadData) safeEmit(const PerformanceState.loading());

    final (statsResult, monthlyResult, leaderboardResult) = await (
      _getPerformanceStats(userId),
      _getMonthlyHours(userId),
      _getLeaderboard(),
    ).wait;

    String? error;
    final stats = statsResult.fold((f) {
      error ??= f.message;
      return null;
    }, (v) => v);
    final monthly = monthlyResult.fold((f) {
      error ??= f.message;
      return null;
    }, (v) => v);
    final leaderboard = leaderboardResult.fold((f) {
      error ??= f.message;
      return null;
    }, (v) => v);

    if (stats == null || monthly == null || leaderboard == null) {
      final message = error ?? '';
      if (!hadData) safeEmit(PerformanceState.error(message));
      return message;
    }

    safeEmit(
      PerformanceState.loaded(
        stats: stats,
        monthlyHours: monthly,
        leaderboard: leaderboard,
        currentUserId: userId,
      ),
    );
    return null;
  }
}
