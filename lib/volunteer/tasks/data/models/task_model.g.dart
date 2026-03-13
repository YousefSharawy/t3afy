// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

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
  supervisorName: json['supervisor_name'] as String? ?? '',
  supervisorPhone: json['supervisor_phone'] as String? ?? '',
  notes: json['notes'] as String? ?? '',
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
      'supervisor_name': instance.supervisorName,
      'supervisor_phone': instance.supervisorPhone,
      'notes': instance.notes,
    };
