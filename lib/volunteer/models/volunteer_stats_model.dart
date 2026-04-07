import 'package:freezed_annotation/freezed_annotation.dart';

part 'volunteer_stats_model.freezed.dart';
part 'volunteer_stats_model.g.dart';

@freezed
abstract class VolunteerStatsModel with _$VolunteerStatsModel {
  const factory VolunteerStatsModel({
    required String id,
    required String name,
    required String email,
    @Default('') String phone,
    @Default('') String role,
    @Default('') String gender,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
    @Default('') String region,
    @Default('') String qualification,
    @Default(1) int level,
    @JsonKey(name: 'level_title') @Default('متطوع جديد') String levelTitle,
    @Default(0.0) double rating,
    @JsonKey(name: 'total_hours') @Default(0) int totalHours,
    @JsonKey(name: 'total_tasks') @Default(0) int totalTasks,
    @JsonKey(name: 'places_visited') @Default(0) int placesVisited,
    @JsonKey(name: 'total_points') @Default(0) int totalPoints,
  }) = _VolunteerStatsModel;

  factory VolunteerStatsModel.fromJson(Map<String, dynamic> json) =>
      _$VolunteerStatsModelFromJson(json);
}
