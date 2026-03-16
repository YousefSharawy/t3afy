part of 'volunteers_cubit.dart';

@freezed
class VolunteersState with _$VolunteersState {
  const factory VolunteersState.initial() = _Initial;
  const factory VolunteersState.loading() = _Loading;
  const factory VolunteersState.loaded(
    List<AdminVolunteerEntity> volunteers, {
    @Default('all') String filter,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory VolunteersState.error(String message) = _Error;
}
