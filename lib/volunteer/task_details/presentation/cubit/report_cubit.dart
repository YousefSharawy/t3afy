import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/get_existing_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/submit_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> with SafeEmit<ReportState> {
  final SubmitReportUseCase _submitReportUseCase;
  final GetExistingReportUseCase _getExistingReportUseCase;

  RealtimeHub? _hub;
  String? _currentTaskId;

  ReportCubit(this._submitReportUseCase, this._getExistingReportUseCase)
    : super(ReportStateInitial());

  void _subscribeToRealtime(String taskId, String userId) {
    _hub?.dispose();
    _hub = RealtimeHub()
      ..watch(
        name: 'report_${taskId}_$userId',
        table: 'task_reports',
        event: PostgresChangeEvent.update,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        ignore: (p) => '${p.newRecord['task_id']}' != taskId,
        onPayload: _patchFromPayload,
        onChange: () => _refreshSilently(taskId, userId),
      );
  }

  /// Approve / reject: the UPDATE row already has the new status and
  /// feedback, so the screen flips instantly without a refetch.
  bool _patchFromPayload(PostgresChangePayload p) {
    final row = p.newRecord;
    if (row['status'] == null || isClosed) return false;
    final current = state;
    if (current is! ReportStateExistingFound) return false;
    safeEmit(
      ReportStateExistingFound({
        ...current.report,
        for (final k in const [
          'id',
          'task_id',
          'user_id',
          'status',
          'admin_feedback',
        ])
          if (row.containsKey(k)) k: row[k],
      }),
    );
    return true;
  }

  /// Admin reviewed the report: swap it in place, keep the old one on failure.
  Future<void> _refreshSilently(String taskId, String userId) async {
    if (isClosed) return;
    final result = await _getExistingReportUseCase(taskId, userId);
    result.fold((_) {}, (report) {
      if (report != null) safeEmit(ReportStateExistingFound(report));
    });
  }

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }

  Future<void> loadExistingReport(String taskId) async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      emit(ReportStateNoExisting());
      return;
    }
    if (_currentTaskId != taskId) {
      _currentTaskId = taskId;
      _subscribeToRealtime(taskId, userId);
    }
    if (state is! ReportStateExistingFound) emit(ReportStateCheckingExisting());
    final result = await _getExistingReportUseCase(taskId, userId);
    result.fold(
      (_) {
        if (state is! ReportStateExistingFound) {
          safeEmit(ReportStateNoExisting());
        }
      },
      (report) => report != null
          ? safeEmit(ReportStateExistingFound(report))
          : safeEmit(ReportStateNoExisting()),
    );
  }

  Future<void> submitReport({
    required String taskId,
    required String summary,
    required String challenges,
    required String attendeesCountStr,
    required String materials,
    required String additionalNotes,
    required int rating,
  }) async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      emit(ReportStateError('لم يتم التعرف على المستخدم'));
      return;
    }
    emit(ReportStateLoading());
    final model = TaskReportModel(
      taskId: taskId,
      userId: userId,
      summary: summary,
      challenges: challenges.isNotEmpty ? challenges : null,
      attendeesCount: int.tryParse(attendeesCountStr),
      materialsDistributed: materials.trim().isNotEmpty,
      additionalNotes: additionalNotes.isNotEmpty ? additionalNotes : null,
      rating: rating,
    );
    final result = await _submitReportUseCase(model);
    result.fold(
      (failure) => safeEmit(ReportStateError(failure.message)),
      (_) => safeEmit(ReportStateSuccess()),
    );
  }
}
