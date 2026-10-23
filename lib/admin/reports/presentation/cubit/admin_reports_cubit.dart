import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';
import 'package:t3afy/admin/reports/domain/usecases/get_reports_usecase.dart';
import 'package:t3afy/admin/reports/domain/usecases/review_report_usecase.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'admin_reports_state.dart';
part 'admin_reports_cubit.freezed.dart';

class AdminReportsCubit extends Cubit<AdminReportsState>
    with SafeEmit<AdminReportsState> {
  AdminReportsCubit(
    this._getReportsUsecase,
    this._reviewReportUsecase,
    this._repo,
  ) : super(const AdminReportsState.initial()) {
    loadReports();
    _repo.subscribeRealtime(
      () => loadReports(),
      ignore: _isOwnReviewEcho,
    );
  }

  final GetReportsUsecase _getReportsUsecase;
  final ReviewReportUsecase _reviewReportUsecase;
  final AdminReportsRepo _repo;

  /// Reports this manager just reviewed → their realtime echo is skipped
  /// (the review already updates the list and does one refresh).
  final Map<String, DateTime> _ownReviews = {};

  bool _isOwnReviewEcho(String? id) {
    final at = _ownReviews[id];
    if (at == null) return false;
    _ownReviews.remove(id);
    return DateTime.now().difference(at) < const Duration(seconds: 15);
  }

  List<AdminReportEntity> get filteredReports {
    return state.maybeWhen(
      loaded: (reports, filter) => filter == 'all'
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

  /// Loads the list. When data is already on screen this is a silent
  /// refresh: no loading state, the selected filter is kept, and a failure
  /// keeps the current list. Returns the error message (null on success) so
  /// pull-to-refresh can show a toast.
  Future<String?> loadReports() async {
    final current = state.maybeWhen(
      loaded: (reports, filter) => (reports: reports, filter: filter),
      orElse: () => null,
    );
    if (current == null) emit(const AdminReportsState.loading());
    final result = await _getReportsUsecase();
    return result.fold(
      (f) {
        if (current == null) safeEmit(AdminReportsState.error(f.message));
        return f.message;
      },
      (list) {
        // Filter may have changed while the request was in flight.
        final filter = state.maybeWhen(
          loaded: (_, filter) => filter,
          orElse: () => current?.filter ?? 'all',
        );
        safeEmit(AdminReportsState.loaded(list, filter: filter));
        return null;
      },
    );
  }

  Future<String?> refresh() => loadReports();

  void setFilter(String filter) {
    state.maybeWhen(
      loaded: (reports, _) =>
          emit(AdminReportsState.loaded(reports, filter: filter)),
      orElse: () {},
    );
  }

  /// Reviews one report without touching the list state: the sheet shows
  /// progress on its own buttons. Returns the error message, or null.
  Future<String?> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
  }) async {
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) return 'تعذّر التحقق من حساب المشرف';
    _ownReviews[reportId] = DateTime.now();
    final result = await _reviewReportUsecase(
      reportId: reportId,
      status: status,
      feedback: feedback,
      adminId: adminId,
    );
    return result.fold(
      (f) {
        _ownReviews.remove(reportId);
        return f.message;
      },
      (_) {
        state.maybeWhen(
          loaded: (reports, filter) => safeEmit(
            AdminReportsState.loaded(
              [
                for (final r in reports)
                  r.id == reportId
                      ? r.reviewed(status: status, feedback: feedback)
                      : r,
              ],
              filter: filter,
            ),
          ),
          orElse: () {},
        );
        loadReports();
        return null;
      },
    );
  }
}
