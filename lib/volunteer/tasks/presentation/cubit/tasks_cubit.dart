import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_completed_tasks.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_tasks_stats.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_today_tasks.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_upcoming_tasks.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> with SafeEmit<TasksState> {
  final GetTodayTasks _getTodayTasks;
  final GetUpcomingTasks _getUpcomingTasks;
  final GetCompletedTasks _getCompletedTasks;
  final GetTasksStats _getTasksStats;
  final RealtimeHub _hub = RealtimeHub();

  /// Ids of the tasks currently shown, so edits to other users' tasks are
  /// ignored instead of reloading this screen on every device.
  Set<String> _taskIds = const {};

  TasksCubit(
    this._getTodayTasks,
    this._getUpcomingTasks,
    this._getCompletedTasks,
    this._getTasksStats,
  ) : super(const TasksState.initial()) {
    final userId = LocalAppStorage.getUserId();
    if (userId != null) _subscribeToRealtime(userId);
  }

  void _subscribeToRealtime(String userId) {
    _hub.watch(
      name: 'tasks_assignments_$userId',
      table: 'task_assignments',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      onChange: _backgroundRefresh,
    );
    // Unassign: DELETE events can't be filtered server-side.
    _hub.watch(
      name: 'tasks_assignments_del_$userId',
      table: 'task_assignments',
      event: PostgresChangeEvent.delete,
      ignore: (p) => deletedRowNotFor(p, 'user_id', userId),
      onChange: _backgroundRefresh,
    );
    // Task field edits (time, place, status) still need to show up, but only
    // for tasks this volunteer actually has.
    _hub.watch(
      name: 'tasks_table_$userId',
      table: 'tasks',
      ignore: (p) => !_taskIds.contains(payloadRowId(p)),
      onChange: _backgroundRefresh,
    );
  }

  bool get _hasData => state is TasksStateLoaded;

  /// Tab open / retry. Uses the cache; with data on screen it refreshes in
  /// place (no skeleton, selected tab kept).
  Future<void> loadTasks() async {
    final silent = _hasData;
    if (!silent) emit(const TasksState.loading());
    await _fetch(skipCache: false, silent: silent);
  }

  /// Pull-to-refresh, return from task details and realtime: bypasses the
  /// cache and keeps current data on failure. Returns false when it failed.
  Future<bool> refresh() => _fetch(skipCache: true, silent: _hasData);

  /// Realtime-driven: never replaces the screen with an error.
  void _backgroundRefresh() => _fetch(skipCache: true, silent: true);

  Future<bool> _fetch({required bool skipCache, required bool silent}) async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      if (!silent) safeEmit(const TasksState.error('User not found'));
      return false;
    }

    final (todayResult, upcomingResult, completedResult, statsResult) = await (
      _getTodayTasks(userId, skipCache: skipCache),
      _getUpcomingTasks(userId, skipCache: skipCache),
      _getCompletedTasks(userId, skipCache: skipCache),
      _getTasksStats(userId, skipCache: skipCache),
    ).wait;

    final stats = statsResult.fold((_) => null, (s) => s);
    if (stats == null) {
      if (!silent) {
        safeEmit(
          TasksState.error(statsResult.fold((f) => f.message, (_) => '')),
        );
      }
      return false;
    }

    final current = state;
    final todayTasks = todayResult.fold(
      (_) => current is TasksStateLoaded ? current.todayTasks : <TaskEntity>[],
      (t) => t,
    );
    final upcomingTasks = upcomingResult.fold(
      (_) =>
          current is TasksStateLoaded ? current.upcomingTasks : <TaskEntity>[],
      (t) => t,
    );
    final completedTasks = completedResult.fold(
      (_) =>
          current is TasksStateLoaded ? current.completedTasks : <TaskEntity>[],
      (t) => t,
    );
    _taskIds = {
      ...todayTasks.map((t) => t.id),
      ...upcomingTasks.map((t) => t.id),
      ...completedTasks.map((t) => t.id),
    };

    safeEmit(
      TasksState.loaded(
        todayTasks: todayTasks,
        upcomingTasks: upcomingTasks,
        completedTasks: completedTasks,
        stats: TasksStatsEntity(
          todayCount: todayTasks.length,
          completedCount: stats.completedCount,
          earnedPoints: stats.earnedPoints,
        ),
        selectedTab: current is TasksStateLoaded ? current.selectedTab : 0,
      ),
    );
    return todayResult.isRight() &&
        upcomingResult.isRight() &&
        completedResult.isRight();
  }

  void switchTab(int index) {
    final currentState = state;
    if (currentState is TasksStateLoaded) {
      emit(currentState.copyWith(selectedTab: index));
    }
  }

  @override
  Future<void> close() async {
    await _hub.dispose();
    return super.close();
  }
}
