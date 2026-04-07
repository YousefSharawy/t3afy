part of 'admin_home_cubit.dart';

@freezed
class AdminHomeState with _$AdminHomeState {
  const factory AdminHomeState.initial() = _Initial;
  const factory AdminHomeState.loading() = _Loading;
  const factory AdminHomeState.loaded(AdminHomeDataEntity data) = _Loaded;
  const factory AdminHomeState.error(String message) = _Error;
  const factory AdminHomeState.announcementSending() = _AnnouncementSending;
  const factory AdminHomeState.announcementSent() = _AnnouncementSent;
  const factory AdminHomeState.announcementError(String message) =
      _AnnouncementError;
  const factory AdminHomeState.exportingPdf() = _ExportingPdf;
  const factory AdminHomeState.exportSuccess() = _ExportSuccess;
  const factory AdminHomeState.exportError(String message) = _ExportError;
}
