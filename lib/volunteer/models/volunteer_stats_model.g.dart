// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VolunteerStatsModel _$VolunteerStatsModelFromJson(Map<String, dynamic> json) =>
    _VolunteerStatsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      region: json['region'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      levelTitle: json['level_title'] as String? ?? 'متطوع جديد',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalHours: (json['total_hours'] as num?)?.toInt() ?? 0,
      totalTasks: (json['total_tasks'] as num?)?.toInt() ?? 0,
      placesVisited: (json['places_visited'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VolunteerStatsModelToJson(
  _VolunteerStatsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'gender': instance.gender,
  'avatar_url': instance.avatarUrl,
  'region': instance.region,
  'qualification': instance.qualification,
  'level': instance.level,
  'level_title': instance.levelTitle,
  'rating': instance.rating,
  'total_hours': instance.totalHours,
  'total_tasks': instance.totalTasks,
  'places_visited': instance.placesVisited,
};
