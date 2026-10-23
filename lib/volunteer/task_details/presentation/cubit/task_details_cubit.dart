import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

import 'package:t3afy/volunteer/task_details/domain/entities/task_details_entity.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/get_task_details_use_case.dart';

part 'task_details_state.dart';
part 'task_details_cubit.freezed.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState>
    with SafeEmit<TaskDetailsState> {
  /// The data source parameter is kept for the DI signature; realtime now
  /// goes through [RealtimeHub].
  TaskDetailsCubit(this._getTaskDetails)
    : super(const TaskDetailsState.initial());

  final GetTaskDetailsUseCase _getTaskDetails;

  RealtimeHub? _hub;
  String? _taskId;

  TaskDetailsEntity? get _task =>
      state.maybeWhen(loaded: (t) => t, orElse: () => null);

  /// First load (and retry from the error state) shows the skeleton; any
  /// later load swaps data in place and never replaces it with an error.
  Future<void> loadTaskDetails(String taskId) async {
    if (_taskId != taskId) {
      _taskId = taskId;
      _subscribe(taskId);
    }
    if (_task == null) emit(const TaskDetailsState.loading());
    await _fetch(taskId);
  }

  /// Pull-to-refresh. Returns an error message when it failed (data is kept).
  Future<String?> refresh() async {
    final id = _taskId;
    if (id == null) return null;
    return _fetch(id);
  }

  Future<String?> _fetch(String taskId) async {
    final result = await _getTaskDetails(taskId);
    return result.fold(
      (failure) {
        if (_task == null) safeEmit(TaskDetailsState.error(failure.message));
        return failure.message;
      },
      (task) {
        safeEmit(TaskDetailsState.loaded(task));
        return null;
      },
    );
  }

  /// Applied locally right after the volunteer's own check-in so the screen
  /// updates without waiting for (and refetching on) the realtime echo.
  void applyCheckIn(DateTime at) {
    final t = _task;
    if (t == null || t.checkedInAt != null) return;
    emit(
      TaskDetailsState.loaded(_copy(t, checkedInAt: at, status: 'in_progress')),
    );
  }

  void applyCheckOut(DateTime inAt, DateTime outAt, double hours) {
    final t = _task;
    if (t == null || t.checkedOutAt != null) return;
    emit(
      TaskDetailsState.loaded(
        _copy(t, checkedInAt: inAt, checkedOutAt: outAt, verifiedHours: hours),
      ),
    );
  }

  void _subscribe(String taskId) {
    _hub?.dispose();
    final hub = _hub = RealtimeHub();
    final userId = LocalAppStorage.getUserId() ?? '';
    hub.watch(
      name: 'task_details_task_$taskId',
      table: 'tasks',
      event: PostgresChangeEvent.update,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: taskId,
      ),
      onChange: _silentRefresh,
    );
    hub.watch(
      name: 'task_details_assignment_${taskId}_$userId',
      table: 'task_assignments',
      event: PostgresChangeEvent.update,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      ignore: (p) =>
          '${p.newRecord['task_id']}' != taskId || _isEcho(p.newRecord),
      onChange: _silentRefresh,
    );
    // Unassigned / task removed while open. Deletes can't be filtered
    // server-side; with REPLICA IDENTITY FULL the old row tells whose it was.
    hub.watch(
      name: 'task_details_assignment_del_$taskId',
      table: 'task_assignments',
      event: PostgresChangeEvent.delete,
      ignore: (p) =>
          deletedRowNotFor(p, 'task_id', taskId) ||
          deletedRowNotFor(p, 'user_id', userId),
      onChange: _silentRefresh,
    );
  }

  /// True when the assignment row carries nothing the screen doesn't already
  /// show — e.g. the echo of our own check-in/out (already applied locally).
  bool _isEcho(Map<String, dynamic> row) {
    final t = _task;
    if (t == null) return false;
    final raw = row['status'] as String?;
    final status = raw == null
        ? null
        : resolveAssignmentStatus(raw, t.date, t.timeEnd);
    final hours = (row['verified_hours'] as num?)?.toDouble();
    return status == t.assignmentStatus &&
        (row['checked_in_at'] != null) == (t.checkedInAt != null) &&
        (row['checked_out_at'] != null) == (t.checkedOutAt != null) &&
        (hours == null || hours == (t.verifiedHours ?? 0));
  }

  Future<void> _silentRefresh() async {
    final id = _taskId;
    if (id == null || isClosed) return;
    final result = await _getTaskDetails(id);
    result.fold((_) {}, (task) => safeEmit(TaskDetailsState.loaded(task)));
  }

  TaskDetailsEntity _copy(
    TaskDetailsEntity t, {
    String? status,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    double? verifiedHours,
  }) {
    return TaskDetailsEntity(
      id: t.id,
      title: t.title,
      type: t.type,
      description: t.description,
      status: t.status,
      date: t.date,
      timeStart: t.timeStart,
      timeEnd: t.timeEnd,
      durationHours: t.durationHours,
      points: t.points,
      locationName: t.locationName,
      locationAddress: t.locationAddress,
      locationLat: t.locationLat,
      locationLng: t.locationLng,
      supervisorName: t.supervisorName,
      supervisorPhone: t.supervisorPhone,
      notes: t.notes,
      assignmentStatus: status ?? t.assignmentStatus,
      checkedInAt: checkedInAt ?? t.checkedInAt,
      checkedOutAt: checkedOutAt ?? t.checkedOutAt,
      verifiedHours: verifiedHours ?? t.verifiedHours,
      isVerified: checkedOutAt != null ? true : t.isVerified,
      objectives: t.objectives,
      supplies: t.supplies,
      papers: t.papers,
    );
  }

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }
}
