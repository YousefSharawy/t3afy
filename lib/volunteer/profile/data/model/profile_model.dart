import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String name,
    required String email,
    @Default('') String phone,
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
    @JsonKey(name: 'joined_at') @Default('') String joinedAt,
    @JsonKey(name: 'id_file_url') String? idFileUrl,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
