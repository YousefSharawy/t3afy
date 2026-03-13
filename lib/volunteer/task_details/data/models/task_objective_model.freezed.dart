// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_objective_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskObjectiveModel {

 String get id;@JsonKey(name: 'task_id') String get taskId; String get title;@JsonKey(name: 'order_index') int get orderIndex;
/// Create a copy of TaskObjectiveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskObjectiveModelCopyWith<TaskObjectiveModel> get copyWith => _$TaskObjectiveModelCopyWithImpl<TaskObjectiveModel>(this as TaskObjectiveModel, _$identity);

  /// Serializes this TaskObjectiveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskObjectiveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,title,orderIndex);

@override
String toString() {
  return 'TaskObjectiveModel(id: $id, taskId: $taskId, title: $title, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class $TaskObjectiveModelCopyWith<$Res>  {
  factory $TaskObjectiveModelCopyWith(TaskObjectiveModel value, $Res Function(TaskObjectiveModel) _then) = _$TaskObjectiveModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'task_id') String taskId, String title,@JsonKey(name: 'order_index') int orderIndex
});




}
/// @nodoc
class _$TaskObjectiveModelCopyWithImpl<$Res>
    implements $TaskObjectiveModelCopyWith<$Res> {
  _$TaskObjectiveModelCopyWithImpl(this._self, this._then);

  final TaskObjectiveModel _self;
  final $Res Function(TaskObjectiveModel) _then;

/// Create a copy of TaskObjectiveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? title = null,Object? orderIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskObjectiveModel].
extension TaskObjectiveModelPatterns on TaskObjectiveModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskObjectiveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskObjectiveModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskObjectiveModel value)  $default,){
final _that = this;
switch (_that) {
case _TaskObjectiveModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskObjectiveModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaskObjectiveModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'task_id')  String taskId,  String title, @JsonKey(name: 'order_index')  int orderIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskObjectiveModel() when $default != null:
return $default(_that.id,_that.taskId,_that.title,_that.orderIndex);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'task_id')  String taskId,  String title, @JsonKey(name: 'order_index')  int orderIndex)  $default,) {final _that = this;
switch (_that) {
case _TaskObjectiveModel():
return $default(_that.id,_that.taskId,_that.title,_that.orderIndex);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'task_id')  String taskId,  String title, @JsonKey(name: 'order_index')  int orderIndex)?  $default,) {final _that = this;
switch (_that) {
case _TaskObjectiveModel() when $default != null:
return $default(_that.id,_that.taskId,_that.title,_that.orderIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskObjectiveModel implements TaskObjectiveModel {
  const _TaskObjectiveModel({required this.id, @JsonKey(name: 'task_id') required this.taskId, required this.title, @JsonKey(name: 'order_index') this.orderIndex = 0});
  factory _TaskObjectiveModel.fromJson(Map<String, dynamic> json) => _$TaskObjectiveModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'task_id') final  String taskId;
@override final  String title;
@override@JsonKey(name: 'order_index') final  int orderIndex;

/// Create a copy of TaskObjectiveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskObjectiveModelCopyWith<_TaskObjectiveModel> get copyWith => __$TaskObjectiveModelCopyWithImpl<_TaskObjectiveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskObjectiveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskObjectiveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,title,orderIndex);

@override
String toString() {
  return 'TaskObjectiveModel(id: $id, taskId: $taskId, title: $title, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class _$TaskObjectiveModelCopyWith<$Res> implements $TaskObjectiveModelCopyWith<$Res> {
  factory _$TaskObjectiveModelCopyWith(_TaskObjectiveModel value, $Res Function(_TaskObjectiveModel) _then) = __$TaskObjectiveModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'task_id') String taskId, String title,@JsonKey(name: 'order_index') int orderIndex
});




}
/// @nodoc
class __$TaskObjectiveModelCopyWithImpl<$Res>
    implements _$TaskObjectiveModelCopyWith<$Res> {
  __$TaskObjectiveModelCopyWithImpl(this._self, this._then);

  final _TaskObjectiveModel _self;
  final $Res Function(_TaskObjectiveModel) _then;

/// Create a copy of TaskObjectiveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? title = null,Object? orderIndex = null,}) {
  return _then(_TaskObjectiveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
