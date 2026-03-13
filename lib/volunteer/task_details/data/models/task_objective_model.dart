import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_objective_model.freezed.dart';
part 'task_objective_model.g.dart';

@freezed
abstract class TaskObjectiveModel with _$TaskObjectiveModel {
  const factory TaskObjectiveModel({
    required String id,
    @JsonKey(name: 'task_id') required String taskId,
    required String title,
    @JsonKey(name: 'order_index') @Default(0) int orderIndex,
  }) = _TaskObjectiveModel;

  factory TaskObjectiveModel.fromJson(Map<String, dynamic> json) =>
      _$TaskObjectiveModelFromJson(json);
}
