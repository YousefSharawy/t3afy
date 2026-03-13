// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_objective_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskObjectiveModel _$TaskObjectiveModelFromJson(Map<String, dynamic> json) =>
    _TaskObjectiveModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      title: json['title'] as String,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TaskObjectiveModelToJson(_TaskObjectiveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'title': instance.title,
      'order_index': instance.orderIndex,
    };
