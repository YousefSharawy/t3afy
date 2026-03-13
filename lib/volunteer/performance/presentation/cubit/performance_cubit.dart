import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  Future<void> loadPerformance(String userId) async {
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
