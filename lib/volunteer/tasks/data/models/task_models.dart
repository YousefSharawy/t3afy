import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

@freezed
abstract class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    required String type,
    @Default('') String description,
    required String status,
    required String date,
    @JsonKey(name: 'time_start') required String timeStart,
    @JsonKey(name: 'time_end') required String timeEnd,
    @JsonKey(name: 'duration_hours') @Default(0.0) double durationHours,
    @Default(0) int points,
    @JsonKey(name: 'location_name') @Default('') String locationName,
    @JsonKey(name: 'location_address') @Default('') String locationAddress,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'supervisor_name') @Default('') String supervisorName,
    @JsonKey(name: 'supervisor_phone') @Default('') String supervisorPhone,
    String? notes,
    @JsonKey(name: 'assignment_status')
    @Default('assigned')
    String assignmentStatus,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

@freezed
abstract class TasksStatsModel with _$TasksStatsModel {
  const factory TasksStatsModel({
    @JsonKey(name: 'today_count') @Default(0) int todayCount,
    @JsonKey(name: 'completed_count') @Default(0) int completedCount,
    @JsonKey(name: 'earned_points') @Default(0) int earnedPoints,
  }) = _TasksStatsModel;

  factory TasksStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TasksStatsModelFromJson(json);
}
