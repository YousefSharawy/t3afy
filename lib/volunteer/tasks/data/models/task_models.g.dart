// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  type: json['type'] as String,
  description: json['description'] as String? ?? '',
  status: json['status'] as String,
  date: json['date'] as String,
  timeStart: json['time_start'] as String,
  timeEnd: json['time_end'] as String,
  durationHours: (json['duration_hours'] as num?)?.toDouble() ?? 0.0,
  points: (json['points'] as num?)?.toInt() ?? 0,
  locationName: json['location_name'] as String? ?? '',
  locationAddress: json['location_address'] as String? ?? '',
  locationLat: (json['location_lat'] as num?)?.toDouble(),
  locationLng: (json['location_lng'] as num?)?.toDouble(),
  supervisorName: json['supervisor_name'] as String? ?? '',
  supervisorPhone: json['supervisor_phone'] as String? ?? '',
  notes: json['notes'] as String?,
  assignmentStatus: json['assignment_status'] as String? ?? 'assigned',
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'description': instance.description,
      'status': instance.status,
      'date': instance.date,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'duration_hours': instance.durationHours,
      'points': instance.points,
      'location_name': instance.locationName,
      'location_address': instance.locationAddress,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'supervisor_name': instance.supervisorName,
      'supervisor_phone': instance.supervisorPhone,
      'notes': instance.notes,
      'assignment_status': instance.assignmentStatus,
    };

_TasksStatsModel _$TasksStatsModelFromJson(Map<String, dynamic> json) =>
    _TasksStatsModel(
      todayCount: (json['today_count'] as num?)?.toInt() ?? 0,
      completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
      earnedPoints: (json['earned_points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TasksStatsModelToJson(_TasksStatsModel instance) =>
    <String, dynamic>{
      'today_count': instance.todayCount,
      'completed_count': instance.completedCount,
      'earned_points': instance.earnedPoints,
    };
