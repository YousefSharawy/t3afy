// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskDetailsModel _$TaskDetailsModelFromJson(Map<String, dynamic> json) =>
    _TaskDetailsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      date: json['date'] as String,
      timeStart: json['time_start'] as String,
      timeEnd: json['time_end'] as String,
      durationHours: (json['duration_hours'] as num?)?.toDouble(),
      points: (json['points'] as num?)?.toInt() ?? 0,
      locationName: json['location_name'] as String?,
      locationAddress: json['location_address'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      supervisorName: json['supervisor_name'] as String?,
      supervisorPhone: json['supervisor_phone'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      createdBy: json['created_by'] as String?,
      assignmentStatus: json['assignment_status'] as String?,
    );

Map<String, dynamic> _$TaskDetailsModelToJson(_TaskDetailsModel instance) =>
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
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'assignment_status': instance.assignmentStatus,
    };
