// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TasksState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TasksState()';
}


}

/// @nodoc
class $TasksStateCopyWith<$Res>  {
$TasksStateCopyWith(TasksState _, $Res Function(TasksState) __);
}


/// Adds pattern-matching-related methods to [TasksState].
extension TasksStatePatterns on TasksState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TasksStateInitial value)?  initial,TResult Function( TasksStateLoading value)?  loading,TResult Function( TasksStateLoaded value)?  loaded,TResult Function( TasksStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TasksStateInitial() when initial != null:
return initial(_that);case TasksStateLoading() when loading != null:
return loading(_that);case TasksStateLoaded() when loaded != null:
return loaded(_that);case TasksStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TasksStateInitial value)  initial,required TResult Function( TasksStateLoading value)  loading,required TResult Function( TasksStateLoaded value)  loaded,required TResult Function( TasksStateError value)  error,}){
final _that = this;
switch (_that) {
case TasksStateInitial():
return initial(_that);case TasksStateLoading():
return loading(_that);case TasksStateLoaded():
return loaded(_that);case TasksStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TasksStateInitial value)?  initial,TResult? Function( TasksStateLoading value)?  loading,TResult? Function( TasksStateLoaded value)?  loaded,TResult? Function( TasksStateError value)?  error,}){
final _that = this;
switch (_that) {
case TasksStateInitial() when initial != null:
return initial(_that);case TasksStateLoading() when loading != null:
return loading(_that);case TasksStateLoaded() when loaded != null:
return loaded(_that);case TasksStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<TaskEntity> todayTasks,  List<TaskEntity> completedTasks,  TasksStatsEntity stats,  int selectedTab)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TasksStateInitial() when initial != null:
return initial();case TasksStateLoading() when loading != null:
return loading();case TasksStateLoaded() when loaded != null:
return loaded(_that.todayTasks,_that.completedTasks,_that.stats,_that.selectedTab);case TasksStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<TaskEntity> todayTasks,  List<TaskEntity> completedTasks,  TasksStatsEntity stats,  int selectedTab)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TasksStateInitial():
return initial();case TasksStateLoading():
return loading();case TasksStateLoaded():
return loaded(_that.todayTasks,_that.completedTasks,_that.stats,_that.selectedTab);case TasksStateError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<TaskEntity> todayTasks,  List<TaskEntity> completedTasks,  TasksStatsEntity stats,  int selectedTab)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TasksStateInitial() when initial != null:
return initial();case TasksStateLoading() when loading != null:
return loading();case TasksStateLoaded() when loaded != null:
return loaded(_that.todayTasks,_that.completedTasks,_that.stats,_that.selectedTab);case TasksStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TasksStateInitial implements TasksState {
  const TasksStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TasksState.initial()';
}


}




/// @nodoc


class TasksStateLoading implements TasksState {
  const TasksStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TasksState.loading()';
}


}




/// @nodoc


class TasksStateLoaded implements TasksState {
  const TasksStateLoaded({required final  List<TaskEntity> todayTasks, required final  List<TaskEntity> completedTasks, required this.stats, this.selectedTab = 0}): _todayTasks = todayTasks,_completedTasks = completedTasks;
  

 final  List<TaskEntity> _todayTasks;
 List<TaskEntity> get todayTasks {
  if (_todayTasks is EqualUnmodifiableListView) return _todayTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todayTasks);
}

 final  List<TaskEntity> _completedTasks;
 List<TaskEntity> get completedTasks {
  if (_completedTasks is EqualUnmodifiableListView) return _completedTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedTasks);
}

 final  TasksStatsEntity stats;
@JsonKey() final  int selectedTab;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasksStateLoadedCopyWith<TasksStateLoaded> get copyWith => _$TasksStateLoadedCopyWithImpl<TasksStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksStateLoaded&&const DeepCollectionEquality().equals(other._todayTasks, _todayTasks)&&const DeepCollectionEquality().equals(other._completedTasks, _completedTasks)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_todayTasks),const DeepCollectionEquality().hash(_completedTasks),stats,selectedTab);

@override
String toString() {
  return 'TasksState.loaded(todayTasks: $todayTasks, completedTasks: $completedTasks, stats: $stats, selectedTab: $selectedTab)';
}


}

/// @nodoc
abstract mixin class $TasksStateLoadedCopyWith<$Res> implements $TasksStateCopyWith<$Res> {
  factory $TasksStateLoadedCopyWith(TasksStateLoaded value, $Res Function(TasksStateLoaded) _then) = _$TasksStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<TaskEntity> todayTasks, List<TaskEntity> completedTasks, TasksStatsEntity stats, int selectedTab
});




}
/// @nodoc
class _$TasksStateLoadedCopyWithImpl<$Res>
    implements $TasksStateLoadedCopyWith<$Res> {
  _$TasksStateLoadedCopyWithImpl(this._self, this._then);

  final TasksStateLoaded _self;
  final $Res Function(TasksStateLoaded) _then;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? todayTasks = null,Object? completedTasks = null,Object? stats = null,Object? selectedTab = null,}) {
  return _then(TasksStateLoaded(
todayTasks: null == todayTasks ? _self._todayTasks : todayTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,completedTasks: null == completedTasks ? _self._completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as TasksStatsEntity,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TasksStateError implements TasksState {
  const TasksStateError(this.message);
  

 final  String message;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasksStateErrorCopyWith<TasksStateError> get copyWith => _$TasksStateErrorCopyWithImpl<TasksStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TasksState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TasksStateErrorCopyWith<$Res> implements $TasksStateCopyWith<$Res> {
  factory $TasksStateErrorCopyWith(TasksStateError value, $Res Function(TasksStateError) _then) = _$TasksStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TasksStateErrorCopyWithImpl<$Res>
    implements $TasksStateErrorCopyWith<$Res> {
  _$TasksStateErrorCopyWithImpl(this._self, this._then);

  final TasksStateError _self;
  final $Res Function(TasksStateError) _then;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TasksStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
