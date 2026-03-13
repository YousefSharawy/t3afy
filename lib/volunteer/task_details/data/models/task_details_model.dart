import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_details_model.freezed.dart';
part 'task_details_model.g.dart';

@freezed
abstract class TaskDetailsModel with _$TaskDetailsModel {
  const factory TaskDetailsModel({
    required String id,
    required String title,
    required String type,
    String? description,
    required String status,
    required String date,
    @JsonKey(name: 'time_start') required String timeStart,
    @JsonKey(name: 'time_end') required String timeEnd,
    @JsonKey(name: 'duration_hours') double? durationHours,
    @Default(0) int points,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'supervisor_name') String? supervisorName,
    @JsonKey(name: 'supervisor_phone') String? supervisorPhone,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'assignment_status') String? assignmentStatus,
  }) = _TaskDetailsModel;

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsModelFromJson(json);
}
