import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_completed_tasks.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_tasks_stats.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_today_tasks.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final GetTodayTasks _getTodayTasks;
  final GetCompletedTasks _getCompletedTasks;
  final GetTasksStats _getTasksStats;

  RealtimeChannel? _assignmentsChannel;
  Timer? _debounce;

  TasksCubit(this._getTodayTasks, this._getCompletedTasks, this._getTasksStats)
      : super(const TasksState.initial()) {
    final userId = LocalAppStorage.getUserId();
    if (userId != null) _subscribeToRealtime(userId);
  }

  void _subscribeToRealtime(String userId) {
    _assignmentsChannel = Supabase.instance.client
        .channel('tasks_assignments_$userId')
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
    _debounce = Timer(const Duration(milliseconds: 500), _silentRefresh);
  }

  Future<void> _silentRefresh() async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;
    final todayResult = await _getTodayTasks(userId);
    final completedResult = await _getCompletedTasks(userId);
    final statsResult = await _getTasksStats(userId);
    statsResult.fold(
      (_) {},
      (stats) {
        final todayTasks = todayResult.fold((_) => <TaskEntity>[], (t) => t);
        final completedTasks = completedResult.fold((_) => <TaskEntity>[], (t) => t);
        final currentTab = state.maybeWhen(
          loaded: (todayTasks, completedTasks, stats, tab) => tab,
          orElse: () => 0,
        );
        emit(TasksState.loaded(
          todayTasks: todayTasks,
          completedTasks: completedTasks,
          stats: stats,
          selectedTab: currentTab,
        ));
      },
    );
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _assignmentsChannel?.unsubscribe();
    return super.close();
  }

  Future<void> loadTasks() async {
    emit(const TasksState.loading());

    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      emit(const TasksState.error('User not found'));
      return;
    }

    final todayResult = await _getTodayTasks(userId);
    final completedResult = await _getCompletedTasks(userId);
    final statsResult = await _getTasksStats(userId);

    statsResult.fold(
      (failure) => emit(TasksState.error(failure.message)),
      (stats) {
        final todayTasks = todayResult.fold((_) => <TaskEntity>[], (t) => t);
        final completedTasks =
            completedResult.fold((_) => <TaskEntity>[], (t) => t);
            

        emit(
          TasksState.loaded(
            todayTasks: todayTasks,
            completedTasks: completedTasks,
            stats: stats,
          ),
        );
      },
    );
  }

void switchTab(int index) {
    final currentState = state;
    if (currentState is TasksStateLoaded) {
      emit(currentState.copyWith(selectedTab: index));
    }
  }
}
