import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_supply_model.freezed.dart';
part 'task_supply_model.g.dart';

@freezed
abstract class TaskSupplyModel with _$TaskSupplyModel {
  const factory TaskSupplyModel({
    required String id,
    @JsonKey(name: 'task_id') required String taskId,
    required String name,
    @Default(1) int quantity,
  }) = _TaskSupplyModel;

  factory TaskSupplyModel.fromJson(Map<String, dynamic> json) =>
      _$TaskSupplyModelFromJson(json);
}
