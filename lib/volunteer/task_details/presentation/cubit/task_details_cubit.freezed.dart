// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState()';
}


}

/// @nodoc
class $TaskDetailsStateCopyWith<$Res>  {
$TaskDetailsStateCopyWith(TaskDetailsState _, $Res Function(TaskDetailsState) __);
}


/// Adds pattern-matching-related methods to [TaskDetailsState].
extension TaskDetailsStatePatterns on TaskDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskDetailsStateInitial value)?  initial,TResult Function( TaskDetailsStateLoading value)?  loading,TResult Function( TaskDetailsStateLoaded value)?  loaded,TResult Function( TaskDetailsStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskDetailsStateInitial() when initial != null:
return initial(_that);case TaskDetailsStateLoading() when loading != null:
return loading(_that);case TaskDetailsStateLoaded() when loaded != null:
return loaded(_that);case TaskDetailsStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskDetailsStateInitial value)  initial,required TResult Function( TaskDetailsStateLoading value)  loading,required TResult Function( TaskDetailsStateLoaded value)  loaded,required TResult Function( TaskDetailsStateError value)  error,}){
final _that = this;
switch (_that) {
case TaskDetailsStateInitial():
return initial(_that);case TaskDetailsStateLoading():
return loading(_that);case TaskDetailsStateLoaded():
return loaded(_that);case TaskDetailsStateError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskDetailsStateInitial value)?  initial,TResult? Function( TaskDetailsStateLoading value)?  loading,TResult? Function( TaskDetailsStateLoaded value)?  loaded,TResult? Function( TaskDetailsStateError value)?  error,}){
final _that = this;
switch (_that) {
case TaskDetailsStateInitial() when initial != null:
return initial(_that);case TaskDetailsStateLoading() when loading != null:
return loading(_that);case TaskDetailsStateLoaded() when loaded != null:
return loaded(_that);case TaskDetailsStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TaskDetailsEntity task)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskDetailsStateInitial() when initial != null:
return initial();case TaskDetailsStateLoading() when loading != null:
return loading();case TaskDetailsStateLoaded() when loaded != null:
return loaded(_that.task);case TaskDetailsStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TaskDetailsEntity task)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TaskDetailsStateInitial():
return initial();case TaskDetailsStateLoading():
return loading();case TaskDetailsStateLoaded():
return loaded(_that.task);case TaskDetailsStateError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TaskDetailsEntity task)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TaskDetailsStateInitial() when initial != null:
return initial();case TaskDetailsStateLoading() when loading != null:
return loading();case TaskDetailsStateLoaded() when loaded != null:
return loaded(_that.task);case TaskDetailsStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TaskDetailsStateInitial implements TaskDetailsState {
  const TaskDetailsStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState.initial()';
}


}




/// @nodoc


class TaskDetailsStateLoading implements TaskDetailsState {
  const TaskDetailsStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState.loading()';
}


}




/// @nodoc


class TaskDetailsStateLoaded implements TaskDetailsState {
  const TaskDetailsStateLoaded(this.task);
  

 final  TaskDetailsEntity task;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailsStateLoadedCopyWith<TaskDetailsStateLoaded> get copyWith => _$TaskDetailsStateLoadedCopyWithImpl<TaskDetailsStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsStateLoaded&&(identical(other.task, task) || other.task == task));
}


@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskDetailsState.loaded(task: $task)';
}


}

/// @nodoc
abstract mixin class $TaskDetailsStateLoadedCopyWith<$Res> implements $TaskDetailsStateCopyWith<$Res> {
  factory $TaskDetailsStateLoadedCopyWith(TaskDetailsStateLoaded value, $Res Function(TaskDetailsStateLoaded) _then) = _$TaskDetailsStateLoadedCopyWithImpl;
@useResult
$Res call({
 TaskDetailsEntity task
});




}
/// @nodoc
class _$TaskDetailsStateLoadedCopyWithImpl<$Res>
    implements $TaskDetailsStateLoadedCopyWith<$Res> {
  _$TaskDetailsStateLoadedCopyWithImpl(this._self, this._then);

  final TaskDetailsStateLoaded _self;
  final $Res Function(TaskDetailsStateLoaded) _then;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,}) {
  return _then(TaskDetailsStateLoaded(
null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TaskDetailsEntity,
  ));
}


}

/// @nodoc


class TaskDetailsStateError implements TaskDetailsState {
  const TaskDetailsStateError(this.message);
  

 final  String message;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailsStateErrorCopyWith<TaskDetailsStateError> get copyWith => _$TaskDetailsStateErrorCopyWithImpl<TaskDetailsStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TaskDetailsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TaskDetailsStateErrorCopyWith<$Res> implements $TaskDetailsStateCopyWith<$Res> {
  factory $TaskDetailsStateErrorCopyWith(TaskDetailsStateError value, $Res Function(TaskDetailsStateError) _then) = _$TaskDetailsStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TaskDetailsStateErrorCopyWithImpl<$Res>
    implements $TaskDetailsStateErrorCopyWith<$Res> {
  _$TaskDetailsStateErrorCopyWithImpl(this._self, this._then);

  final TaskDetailsStateError _self;
  final $Res Function(TaskDetailsStateError) _then;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TaskDetailsStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
