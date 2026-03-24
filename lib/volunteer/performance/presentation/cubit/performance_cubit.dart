import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  Timer? _debounce;
  String? _currentUserId;

  void _subscribeToRealtime(String userId) {
    _usersChannel?.unsubscribe();
    _usersChannel = Supabase.instance.client
        .channel('volunteer_performance_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
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
  }

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_currentUserId != null) loadPerformance(_currentUserId!);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _usersChannel?.unsubscribe();
    return super.close();
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
              (leaderboard) => emit(PerformanceState.loaded(
                stats: stats,
                monthlyHours: monthly,
                leaderboard: leaderboard,
                currentUserId: userId,
              )),
            );
          },
        );
      },
    );
  }
}
