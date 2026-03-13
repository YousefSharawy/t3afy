part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required VolunteerStatsEntity stats,
    required List<TaskEntity> todayTasks,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}