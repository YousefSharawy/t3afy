// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_supply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskSupplyModel {

 String get id;@JsonKey(name: 'task_id') String get taskId; String get name; int get quantity;
/// Create a copy of TaskSupplyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSupplyModelCopyWith<TaskSupplyModel> get copyWith => _$TaskSupplyModelCopyWithImpl<TaskSupplyModel>(this as TaskSupplyModel, _$identity);

  /// Serializes this TaskSupplyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSupplyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,name,quantity);

@override
String toString() {
  return 'TaskSupplyModel(id: $id, taskId: $taskId, name: $name, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $TaskSupplyModelCopyWith<$Res>  {
  factory $TaskSupplyModelCopyWith(TaskSupplyModel value, $Res Function(TaskSupplyModel) _then) = _$TaskSupplyModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'task_id') String taskId, String name, int quantity
});




}
/// @nodoc
class _$TaskSupplyModelCopyWithImpl<$Res>
    implements $TaskSupplyModelCopyWith<$Res> {
  _$TaskSupplyModelCopyWithImpl(this._self, this._then);

  final TaskSupplyModel _self;
  final $Res Function(TaskSupplyModel) _then;

/// Create a copy of TaskSupplyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? name = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSupplyModel].
extension TaskSupplyModelPatterns on TaskSupplyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSupplyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSupplyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSupplyModel value)  $default,){
final _that = this;
switch (_that) {
case _TaskSupplyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSupplyModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSupplyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'task_id')  String taskId,  String name,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSupplyModel() when $default != null:
return $default(_that.id,_that.taskId,_that.name,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'task_id')  String taskId,  String name,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _TaskSupplyModel():
return $default(_that.id,_that.taskId,_that.name,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'task_id')  String taskId,  String name,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _TaskSupplyModel() when $default != null:
return $default(_that.id,_that.taskId,_that.name,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSupplyModel implements TaskSupplyModel {
  const _TaskSupplyModel({required this.id, @JsonKey(name: 'task_id') required this.taskId, required this.name, this.quantity = 1});
  factory _TaskSupplyModel.fromJson(Map<String, dynamic> json) => _$TaskSupplyModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'task_id') final  String taskId;
@override final  String name;
@override@JsonKey() final  int quantity;

/// Create a copy of TaskSupplyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSupplyModelCopyWith<_TaskSupplyModel> get copyWith => __$TaskSupplyModelCopyWithImpl<_TaskSupplyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSupplyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSupplyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,name,quantity);

@override
String toString() {
  return 'TaskSupplyModel(id: $id, taskId: $taskId, name: $name, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$TaskSupplyModelCopyWith<$Res> implements $TaskSupplyModelCopyWith<$Res> {
  factory _$TaskSupplyModelCopyWith(_TaskSupplyModel value, $Res Function(_TaskSupplyModel) _then) = __$TaskSupplyModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'task_id') String taskId, String name, int quantity
});




}
/// @nodoc
class __$TaskSupplyModelCopyWithImpl<$Res>
    implements _$TaskSupplyModelCopyWith<$Res> {
  __$TaskSupplyModelCopyWithImpl(this._self, this._then);

  final _TaskSupplyModel _self;
  final $Res Function(_TaskSupplyModel) _then;

/// Create a copy of TaskSupplyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? name = null,Object? quantity = null,}) {
  return _then(_TaskSupplyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
