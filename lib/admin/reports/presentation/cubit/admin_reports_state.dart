part of 'admin_reports_cubit.dart';

@freezed
class AdminReportsState with _$AdminReportsState {
  const factory AdminReportsState.initial() = _Initial;
  const factory AdminReportsState.loading() = _Loading;
  const factory AdminReportsState.loaded(
    List<AdminReportEntity> reports, {
    @Default('all') String filter,
  }) = _Loaded;
  const factory AdminReportsState.error(String message) = _Error;
  const factory AdminReportsState.reviewing() = _Reviewing;
  const factory AdminReportsState.reviewed() = _Reviewed;
}
