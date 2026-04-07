import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/volunteer/performance/domain/use_cases/performance_use_cases.dart';

part 'performance_state.dart';
part 'performance_cubit.freezed.dart';

class PerformanceCubit extends Cubit<PerformanceState> {
  PerformanceCubit(
    this._getPerformanceStats,
    this._getMonthlyHours,
    this._getLeaderboard,
  ) : super(const PerformanceState.initial());

  final GetPerformanceStats _getPerformanceStats;
  final GetMonthlyHours _getMonthlyHours;
  final GetLeaderboard _getLeaderboard;

  RealtimeChannel? _usersChannel;
  RealtimeChannel? _assignmentsChannel;
  Timer? _debounce;
  String? _currentUserId;

  void _subscribeToRealtime(String userId) {
    _usersChannel?.unsubscribe();
    _usersChannel = Supabase.instance.client
        .channel('volunteer_performance_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();

    _assignmentsChannel?.unsubscribe();
    _assignmentsChannel = Supabase.instance.client
        .channel('volunteer_performance_assignments_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_assignments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();
  }

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (_currentUserId == null) return;
      await LocalAppStorage.invalidateCache('perf_stats_$_currentUserId');
      await LocalAppStorage.invalidateCache('monthly_hours_$_currentUserId');
      await LocalAppStorage.invalidateCache('leaderboard_v2');
      await loadPerformance(_currentUserId!);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    final client = Supabase.instance.client;
    if (_usersChannel != null) client.removeChannel(_usersChannel!);
    if (_assignmentsChannel != null) client.removeChannel(_assignmentsChannel!);
    return super.close();
  }

  /// Invalidates all performance cache keys then reloads fresh data.
  /// Wire this to RefreshIndicator.onRefresh instead of loadPerformance().
  Future<void> refreshPerformance() async {
    final userId = _currentUserId;
    if (userId == null) return;
    await LocalAppStorage.invalidateCache('perf_stats_$userId');
    await LocalAppStorage.invalidateCache('monthly_hours_$userId');
    await LocalAppStorage.invalidateCache('leaderboard_v2');
    await loadPerformance(userId);
  }

  Future<void> loadPerformance(String userId) async {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      _subscribeToRealtime(userId);
    }
    emit(const PerformanceState.loading());

    final statsResult = await _getPerformanceStats(userId);
    final monthlyResult = await _getMonthlyHours(userId);
    final leaderboardResult = await _getLeaderboard();

    statsResult.fold(
      (failure) => emit(PerformanceState.error(failure.message)),
      (stats) {
        monthlyResult.fold(
          (failure) => emit(PerformanceState.error(failure.message)),
          (monthly) {
            leaderboardResult.fold(
              (failure) => emit(PerformanceState.error(failure.message)),
              (leaderboard) => emit(
                PerformanceState.loaded(
                  stats: stats,
                  monthlyHours: monthly,
                  leaderboard: leaderboard,
                  currentUserId: userId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
