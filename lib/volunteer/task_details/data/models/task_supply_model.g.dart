// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_supply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskSupplyModel _$TaskSupplyModelFromJson(Map<String, dynamic> json) =>
    _TaskSupplyModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$TaskSupplyModelToJson(_TaskSupplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'name': instance.name,
      'quantity': instance.quantity,
    };
