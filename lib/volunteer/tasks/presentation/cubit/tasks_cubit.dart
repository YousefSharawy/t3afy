import 'package:flutter_bloc/flutter_bloc.dart';
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

  TasksCubit(this._getTodayTasks, this._getCompletedTasks, this._getTasksStats)
      : super(const TasksState.initial());

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
