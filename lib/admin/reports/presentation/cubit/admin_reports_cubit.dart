import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';
import 'package:t3afy/admin/reports/domain/usecases/get_reports_usecase.dart';
import 'package:t3afy/admin/reports/domain/usecases/review_report_usecase.dart';

part 'admin_reports_state.dart';
part 'admin_reports_cubit.freezed.dart';

class AdminReportsCubit extends Cubit<AdminReportsState> {
  AdminReportsCubit(
    this._getReportsUsecase,
    this._reviewReportUsecase,
    this._repo,
  ) : super(const AdminReportsState.initial()) {
    loadReports();
    _repo.subscribeRealtime(() => loadReports());
  }

  final GetReportsUsecase _getReportsUsecase;
  final ReviewReportUsecase _reviewReportUsecase;
  final AdminReportsRepo _repo;

  List<AdminReportEntity> get filteredReports {
    return state.maybeWhen(
      loaded: (reports, filter) =>
          filter == 'all'
              ? reports
              : reports.where((r) => r.status == filter).toList(),
      orElse: () => [],
    );
  }

  @override
  Future<void> close() {
    _repo.disposeRealtime();
    return super.close();
  }

  Future<void> loadReports() async {
    emit(const AdminReportsState.loading());
    final result = await _getReportsUsecase();
    result.fold(
      (f) => emit(AdminReportsState.error(f.message)),
      (list) => emit(AdminReportsState.loaded(list, filter: 'all')),
    );
  }

  void setFilter(String filter) {
    state.maybeWhen(
      loaded: (reports, _) =>
          emit(AdminReportsState.loaded(reports, filter: filter)),
      orElse: () {},
    );
  }

  Future<void> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
  }) async {
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) return;
    emit(const AdminReportsState.reviewing());
    final result = await _reviewReportUsecase(
      reportId: reportId,
      status: status,
      feedback: feedback,
      adminId: adminId,
    );
    result.fold(
      (f) => emit(AdminReportsState.error(f.message)),
      (_) {
        emit(const AdminReportsState.reviewed());
        loadReports();
      },
    );
  }
}
