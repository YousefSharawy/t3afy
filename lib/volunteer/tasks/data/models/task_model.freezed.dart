// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskModel {

 String get id; String get title; String get type; String get description; String get status; String get date;@JsonKey(name: 'time_start') String get timeStart;@JsonKey(name: 'time_end') String get timeEnd;@JsonKey(name: 'duration_hours') double get durationHours; int get points;@JsonKey(name: 'location_name') String get locationName;@JsonKey(name: 'location_address') String get locationAddress;@JsonKey(name: 'supervisor_name') String get supervisorName;@JsonKey(name: 'supervisor_phone') String get supervisorPhone; String get notes;
/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskModelCopyWith<TaskModel> get copyWith => _$TaskModelCopyWithImpl<TaskModel>(this as TaskModel, _$identity);

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.date, date) || other.date == date)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.points, points) || other.points == points)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.locationAddress, locationAddress) || other.locationAddress == locationAddress)&&(identical(other.supervisorName, supervisorName) || other.supervisorName == supervisorName)&&(identical(other.supervisorPhone, supervisorPhone) || other.supervisorPhone == supervisorPhone)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,description,status,date,timeStart,timeEnd,durationHours,points,locationName,locationAddress,supervisorName,supervisorPhone,notes);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, type: $type, description: $description, status: $status, date: $date, timeStart: $timeStart, timeEnd: $timeEnd, durationHours: $durationHours, points: $points, locationName: $locationName, locationAddress: $locationAddress, supervisorName: $supervisorName, supervisorPhone: $supervisorPhone, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $TaskModelCopyWith<$Res>  {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) _then) = _$TaskModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String type, String description, String status, String date,@JsonKey(name: 'time_start') String timeStart,@JsonKey(name: 'time_end') String timeEnd,@JsonKey(name: 'duration_hours') double durationHours, int points,@JsonKey(name: 'location_name') String locationName,@JsonKey(name: 'location_address') String locationAddress,@JsonKey(name: 'supervisor_name') String supervisorName,@JsonKey(name: 'supervisor_phone') String supervisorPhone, String notes
});




}
/// @nodoc
class _$TaskModelCopyWithImpl<$Res>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._self, this._then);

  final TaskModel _self;
  final $Res Function(TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? description = null,Object? status = null,Object? date = null,Object? timeStart = null,Object? timeEnd = null,Object? durationHours = null,Object? points = null,Object? locationName = null,Object? locationAddress = null,Object? supervisorName = null,Object? supervisorPhone = null,Object? notes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timeStart: null == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String,timeEnd: null == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String,durationHours: null == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,locationAddress: null == locationAddress ? _self.locationAddress : locationAddress // ignore: cast_nullable_to_non_nullable
as String,supervisorName: null == supervisorName ? _self.supervisorName : supervisorName // ignore: cast_nullable_to_non_nullable
as String,supervisorPhone: null == supervisorPhone ? _self.supervisorPhone : supervisorPhone // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskModel].
extension TaskModelPatterns on TaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskModel value)  $default,){
final _that = this;
switch (_that) {
case _TaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String description,  String status,  String date, @JsonKey(name: 'time_start')  String timeStart, @JsonKey(name: 'time_end')  String timeEnd, @JsonKey(name: 'duration_hours')  double durationHours,  int points, @JsonKey(name: 'location_name')  String locationName, @JsonKey(name: 'location_address')  String locationAddress, @JsonKey(name: 'supervisor_name')  String supervisorName, @JsonKey(name: 'supervisor_phone')  String supervisorPhone,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.description,_that.status,_that.date,_that.timeStart,_that.timeEnd,_that.durationHours,_that.points,_that.locationName,_that.locationAddress,_that.supervisorName,_that.supervisorPhone,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String description,  String status,  String date, @JsonKey(name: 'time_start')  String timeStart, @JsonKey(name: 'time_end')  String timeEnd, @JsonKey(name: 'duration_hours')  double durationHours,  int points, @JsonKey(name: 'location_name')  String locationName, @JsonKey(name: 'location_address')  String locationAddress, @JsonKey(name: 'supervisor_name')  String supervisorName, @JsonKey(name: 'supervisor_phone')  String supervisorPhone,  String notes)  $default,) {final _that = this;
switch (_that) {
case _TaskModel():
return $default(_that.id,_that.title,_that.type,_that.description,_that.status,_that.date,_that.timeStart,_that.timeEnd,_that.durationHours,_that.points,_that.locationName,_that.locationAddress,_that.supervisorName,_that.supervisorPhone,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String type,  String description,  String status,  String date, @JsonKey(name: 'time_start')  String timeStart, @JsonKey(name: 'time_end')  String timeEnd, @JsonKey(name: 'duration_hours')  double durationHours,  int points, @JsonKey(name: 'location_name')  String locationName, @JsonKey(name: 'location_address')  String locationAddress, @JsonKey(name: 'supervisor_name')  String supervisorName, @JsonKey(name: 'supervisor_phone')  String supervisorPhone,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.description,_that.status,_that.date,_that.timeStart,_that.timeEnd,_that.durationHours,_that.points,_that.locationName,_that.locationAddress,_that.supervisorName,_that.supervisorPhone,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskModel implements TaskModel {
  const _TaskModel({required this.id, required this.title, required this.type, this.description = '', required this.status, required this.date, @JsonKey(name: 'time_start') required this.timeStart, @JsonKey(name: 'time_end') required this.timeEnd, @JsonKey(name: 'duration_hours') this.durationHours = 0.0, this.points = 0, @JsonKey(name: 'location_name') this.locationName = '', @JsonKey(name: 'location_address') this.locationAddress = '', @JsonKey(name: 'supervisor_name') this.supervisorName = '', @JsonKey(name: 'supervisor_phone') this.supervisorPhone = '', this.notes = ''});
  factory _TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String type;
@override@JsonKey() final  String description;
@override final  String status;
@override final  String date;
@override@JsonKey(name: 'time_start') final  String timeStart;
@override@JsonKey(name: 'time_end') final  String timeEnd;
@override@JsonKey(name: 'duration_hours') final  double durationHours;
@override@JsonKey() final  int points;
@override@JsonKey(name: 'location_name') final  String locationName;
@override@JsonKey(name: 'location_address') final  String locationAddress;
@override@JsonKey(name: 'supervisor_name') final  String supervisorName;
@override@JsonKey(name: 'supervisor_phone') final  String supervisorPhone;
@override@JsonKey() final  String notes;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskModelCopyWith<_TaskModel> get copyWith => __$TaskModelCopyWithImpl<_TaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.date, date) || other.date == date)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.points, points) || other.points == points)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.locationAddress, locationAddress) || other.locationAddress == locationAddress)&&(identical(other.supervisorName, supervisorName) || other.supervisorName == supervisorName)&&(identical(other.supervisorPhone, supervisorPhone) || other.supervisorPhone == supervisorPhone)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,description,status,date,timeStart,timeEnd,durationHours,points,locationName,locationAddress,supervisorName,supervisorPhone,notes);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, type: $type, description: $description, status: $status, date: $date, timeStart: $timeStart, timeEnd: $timeEnd, durationHours: $durationHours, points: $points, locationName: $locationName, locationAddress: $locationAddress, supervisorName: $supervisorName, supervisorPhone: $supervisorPhone, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$TaskModelCopyWith<$Res> implements $TaskModelCopyWith<$Res> {
  factory _$TaskModelCopyWith(_TaskModel value, $Res Function(_TaskModel) _then) = __$TaskModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String type, String description, String status, String date,@JsonKey(name: 'time_start') String timeStart,@JsonKey(name: 'time_end') String timeEnd,@JsonKey(name: 'duration_hours') double durationHours, int points,@JsonKey(name: 'location_name') String locationName,@JsonKey(name: 'location_address') String locationAddress,@JsonKey(name: 'supervisor_name') String supervisorName,@JsonKey(name: 'supervisor_phone') String supervisorPhone, String notes
});




}
/// @nodoc
class __$TaskModelCopyWithImpl<$Res>
    implements _$TaskModelCopyWith<$Res> {
  __$TaskModelCopyWithImpl(this._self, this._then);

  final _TaskModel _self;
  final $Res Function(_TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? description = null,Object? status = null,Object? date = null,Object? timeStart = null,Object? timeEnd = null,Object? durationHours = null,Object? points = null,Object? locationName = null,Object? locationAddress = null,Object? supervisorName = null,Object? supervisorPhone = null,Object? notes = null,}) {
  return _then(_TaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timeStart: null == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String,timeEnd: null == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String,durationHours: null == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,locationAddress: null == locationAddress ? _self.locationAddress : locationAddress // ignore: cast_nullable_to_non_nullable
as String,supervisorName: null == supervisorName ? _self.supervisorName : supervisorName // ignore: cast_nullable_to_non_nullable
as String,supervisorPhone: null == supervisorPhone ? _self.supervisorPhone : supervisorPhone // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
