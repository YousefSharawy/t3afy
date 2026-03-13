import 'package:freezed_annotation/freezed_annotation.dart';

part 'performance_models.freezed.dart';
part 'performance_models.g.dart';

@freezed
abstract class PerformanceStatsModel with _$PerformanceStatsModel {
  const factory PerformanceStatsModel({
    required String name,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
    @Default(0.0) double rating,
    @Default(1) int level,
    @JsonKey(name: 'level_title') @Default('متطوع جديد') String levelTitle,
    @JsonKey(name: 'total_hours') @Default(0) int totalHours,
    @JsonKey(name: 'places_visited') @Default(0) int placesVisited,
    @JsonKey(name: 'total_points') @Default(0) int totalPoints,
  }) = _PerformanceStatsModel;

  factory PerformanceStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PerformanceStatsModelFromJson(json);
}

@freezed
abstract class MonthlyHoursModel with _$MonthlyHoursModel {
  const factory MonthlyHoursModel({
    required int year,
    required int month,
    @Default(0.0) double hours,
  }) = _MonthlyHoursModel;

  factory MonthlyHoursModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyHoursModelFromJson(json);
}

@freezed
abstract class LeaderboardEntryModel with _$LeaderboardEntryModel {
  const factory LeaderboardEntryModel({
    required String id,
    required String name,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
    @JsonKey(name: 'total_hours') @Default(0) int totalHours,
    @Default(0) int pts,
  }) = _LeaderboardEntryModel;

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);
}
