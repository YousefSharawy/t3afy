import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';

import 'package:t3afy/volunteer/task_details/data/sources/task_details_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_details_entity.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/get_task_details_use_case.dart';

part 'task_details_state.dart';
part 'task_details_cubit.freezed.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsCubit(this._getTaskDetails, this._dataSource)
      : super(const TaskDetailsState.initial());

  final GetTaskDetailsUseCase _getTaskDetails;
  final TaskDetailsImplRemoteDataSource _dataSource;

  RealtimeChannel? _taskChannel;
  RealtimeChannel? _assignmentChannel;
  Timer? _debounce;
  String? _currentTaskId;

  Future<void> loadTaskDetails(String taskId) async {
    _currentTaskId = taskId;
    emit(const TaskDetailsState.loading());

    final result = await _getTaskDetails(taskId);
    result.fold(
      (failure) => emit(TaskDetailsState.error(failure.message)),
      (task) {
        emit(TaskDetailsState.loaded(task));
        _subscribeToRealtime(taskId);
      },
    );
  }

  void _subscribeToRealtime(String taskId) {
    _taskChannel = _dataSource.subscribeToTask(taskId, (_) => _onRealtimeEvent());
    _assignmentChannel =
        _dataSource.subscribeToAssignment(taskId, (_) => _onRealtimeEvent());
  }

  void _onRealtimeEvent() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _refetch);
  }

  Future<void> _refetch() async {
    final taskId = _currentTaskId;
    if (taskId == null) return;
    await LocalAppStorage.invalidateCache('task_details_$taskId');
    final result = await _getTaskDetails(taskId);
    result.fold(
      (failure) => emit(TaskDetailsState.error(failure.message)),
      (task) => emit(TaskDetailsState.loaded(task)),
    );
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    if (_taskChannel != null) {
      await _dataSource.unsubscribe(_taskChannel!);
    }
    if (_assignmentChannel != null) {
      await _dataSource.unsubscribe(_assignmentChannel!);
    }
    return super.close();
  }
}
