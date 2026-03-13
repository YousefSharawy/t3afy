import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

part 'tasks_state.freezed.dart';
@freezed
abstract class TasksState with _$TasksState {
  const factory TasksState.initial() = TasksStateInitial;
  const factory TasksState.loading() = TasksStateLoading;
  const factory TasksState.loaded({
    required List<TaskEntity> todayTasks,
    required List<TaskEntity> completedTasks,
    required TasksStatsEntity stats,
    @Default(0) int selectedTab,
  }) = TasksStateLoaded;
  const factory TasksState.error(String message) = TasksStateError;
}
