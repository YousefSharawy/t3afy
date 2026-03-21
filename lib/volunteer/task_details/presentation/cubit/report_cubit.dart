import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/get_existing_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/submit_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUseCase _submitReportUseCase;
  final GetExistingReportUseCase _getExistingReportUseCase;

  ReportCubit(this._submitReportUseCase, this._getExistingReportUseCase)
      : super(ReportStateInitial());

  Future<void> loadExistingReport(String taskId) async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      emit(ReportStateNoExisting());
      return;
    }
    emit(ReportStateCheckingExisting());
    final result = await _getExistingReportUseCase(taskId, userId);
    result.fold(
      (_) => emit(ReportStateNoExisting()),
      (report) => report != null
          ? emit(ReportStateExistingFound(report))
          : emit(ReportStateNoExisting()),
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
      (failure) => emit(ReportStateError(failure.message)),
      (_) => emit(ReportStateSuccess()),
    );
  }
}
