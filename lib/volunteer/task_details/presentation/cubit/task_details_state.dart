part of 'task_details_cubit.dart';

@freezed
class TaskDetailsState with _$TaskDetailsState {
  const factory TaskDetailsState.initial() = TaskDetailsStateInitial;
  const factory TaskDetailsState.loading() = TaskDetailsStateLoading;
  const factory TaskDetailsState.loaded(TaskDetailsEntity task) =
      TaskDetailsStateLoaded;
  const factory TaskDetailsState.error(String message) = TaskDetailsStateError;
}
