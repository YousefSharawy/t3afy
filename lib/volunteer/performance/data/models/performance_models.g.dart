// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PerformanceStatsModel _$PerformanceStatsModelFromJson(
  Map<String, dynamic> json,
) => _PerformanceStatsModel(
  name: json['name'] as String,
  avatarUrl: json['avatar_url'] as String? ?? '',
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  levelTitle: json['level_title'] as String? ?? 'متطوع جديد',
  totalHours: (json['total_hours'] as num?)?.toInt() ?? 0,
  placesVisited: (json['places_visited'] as num?)?.toInt() ?? 0,
  totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PerformanceStatsModelToJson(
  _PerformanceStatsModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'avatar_url': instance.avatarUrl,
  'rating': instance.rating,
  'level': instance.level,
  'level_title': instance.levelTitle,
  'total_hours': instance.totalHours,
  'places_visited': instance.placesVisited,
  'total_points': instance.totalPoints,
};

_MonthlyHoursModel _$MonthlyHoursModelFromJson(Map<String, dynamic> json) =>
    _MonthlyHoursModel(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      hours: (json['hours'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$MonthlyHoursModelToJson(_MonthlyHoursModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'hours': instance.hours,
    };

_LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
  Map<String, dynamic> json,
) => _LeaderboardEntryModel(
  id: json['id'] as String,
  name: json['name'] as String,
  avatarUrl: json['avatar_url'] as String? ?? '',
  totalHours: (json['total_hours'] as num?)?.toInt() ?? 0,
  pts: (json['pts'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LeaderboardEntryModelToJson(
  _LeaderboardEntryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_url': instance.avatarUrl,
  'total_hours': instance.totalHours,
  'pts': instance.pts,
};
