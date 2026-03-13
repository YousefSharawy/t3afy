import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/submit_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUseCase _submitReportUseCase;

  ReportCubit(this._submitReportUseCase) : super(ReportStateInitial());

  Future<void> submitReport(TaskReportModel model) async {
    emit(ReportStateLoading());
    final result = await _submitReportUseCase(model);
    result.fold(
      (failure) => emit(ReportStateError(failure.message)),
      (_) => emit(ReportStateSuccess()),
    );
  }
}
