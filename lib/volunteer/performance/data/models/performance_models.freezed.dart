// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerformanceStatsModel {

 String get name;@JsonKey(name: 'avatar_url') String get avatarUrl; double get rating; int get level;@JsonKey(name: 'level_title') String get levelTitle;@JsonKey(name: 'total_hours') int get totalHours;@JsonKey(name: 'places_visited') int get placesVisited;@JsonKey(name: 'total_points') int get totalPoints;
/// Create a copy of PerformanceStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerformanceStatsModelCopyWith<PerformanceStatsModel> get copyWith => _$PerformanceStatsModelCopyWithImpl<PerformanceStatsModel>(this as PerformanceStatsModel, _$identity);

  /// Serializes this PerformanceStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerformanceStatsModel&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,avatarUrl,rating,level,levelTitle,totalHours,placesVisited,totalPoints);

@override
String toString() {
  return 'PerformanceStatsModel(name: $name, avatarUrl: $avatarUrl, rating: $rating, level: $level, levelTitle: $levelTitle, totalHours: $totalHours, placesVisited: $placesVisited, totalPoints: $totalPoints)';
}


}

/// @nodoc
abstract mixin class $PerformanceStatsModelCopyWith<$Res>  {
  factory $PerformanceStatsModelCopyWith(PerformanceStatsModel value, $Res Function(PerformanceStatsModel) _then) = _$PerformanceStatsModelCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'avatar_url') String avatarUrl, double rating, int level,@JsonKey(name: 'level_title') String levelTitle,@JsonKey(name: 'total_hours') int totalHours,@JsonKey(name: 'places_visited') int placesVisited,@JsonKey(name: 'total_points') int totalPoints
});




}
/// @nodoc
class _$PerformanceStatsModelCopyWithImpl<$Res>
    implements $PerformanceStatsModelCopyWith<$Res> {
  _$PerformanceStatsModelCopyWithImpl(this._self, this._then);

  final PerformanceStatsModel _self;
  final $Res Function(PerformanceStatsModel) _then;

/// Create a copy of PerformanceStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatarUrl = null,Object? rating = null,Object? level = null,Object? levelTitle = null,Object? totalHours = null,Object? placesVisited = null,Object? totalPoints = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PerformanceStatsModel].
extension PerformanceStatsModelPatterns on PerformanceStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerformanceStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerformanceStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerformanceStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _PerformanceStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerformanceStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _PerformanceStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'avatar_url')  String avatarUrl,  double rating,  int level, @JsonKey(name: 'level_title')  String levelTitle, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'places_visited')  int placesVisited, @JsonKey(name: 'total_points')  int totalPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PerformanceStatsModel() when $default != null:
return $default(_that.name,_that.avatarUrl,_that.rating,_that.level,_that.levelTitle,_that.totalHours,_that.placesVisited,_that.totalPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'avatar_url')  String avatarUrl,  double rating,  int level, @JsonKey(name: 'level_title')  String levelTitle, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'places_visited')  int placesVisited, @JsonKey(name: 'total_points')  int totalPoints)  $default,) {final _that = this;
switch (_that) {
case _PerformanceStatsModel():
return $default(_that.name,_that.avatarUrl,_that.rating,_that.level,_that.levelTitle,_that.totalHours,_that.placesVisited,_that.totalPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'avatar_url')  String avatarUrl,  double rating,  int level, @JsonKey(name: 'level_title')  String levelTitle, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'places_visited')  int placesVisited, @JsonKey(name: 'total_points')  int totalPoints)?  $default,) {final _that = this;
switch (_that) {
case _PerformanceStatsModel() when $default != null:
return $default(_that.name,_that.avatarUrl,_that.rating,_that.level,_that.levelTitle,_that.totalHours,_that.placesVisited,_that.totalPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PerformanceStatsModel implements PerformanceStatsModel {
  const _PerformanceStatsModel({required this.name, @JsonKey(name: 'avatar_url') this.avatarUrl = '', this.rating = 0.0, this.level = 1, @JsonKey(name: 'level_title') this.levelTitle = 'متطوع جديد', @JsonKey(name: 'total_hours') this.totalHours = 0, @JsonKey(name: 'places_visited') this.placesVisited = 0, @JsonKey(name: 'total_points') this.totalPoints = 0});
  factory _PerformanceStatsModel.fromJson(Map<String, dynamic> json) => _$PerformanceStatsModelFromJson(json);

@override final  String name;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int level;
@override@JsonKey(name: 'level_title') final  String levelTitle;
@override@JsonKey(name: 'total_hours') final  int totalHours;
@override@JsonKey(name: 'places_visited') final  int placesVisited;
@override@JsonKey(name: 'total_points') final  int totalPoints;

/// Create a copy of PerformanceStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerformanceStatsModelCopyWith<_PerformanceStatsModel> get copyWith => __$PerformanceStatsModelCopyWithImpl<_PerformanceStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerformanceStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerformanceStatsModel&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,avatarUrl,rating,level,levelTitle,totalHours,placesVisited,totalPoints);

@override
String toString() {
  return 'PerformanceStatsModel(name: $name, avatarUrl: $avatarUrl, rating: $rating, level: $level, levelTitle: $levelTitle, totalHours: $totalHours, placesVisited: $placesVisited, totalPoints: $totalPoints)';
}


}

/// @nodoc
abstract mixin class _$PerformanceStatsModelCopyWith<$Res> implements $PerformanceStatsModelCopyWith<$Res> {
  factory _$PerformanceStatsModelCopyWith(_PerformanceStatsModel value, $Res Function(_PerformanceStatsModel) _then) = __$PerformanceStatsModelCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'avatar_url') String avatarUrl, double rating, int level,@JsonKey(name: 'level_title') String levelTitle,@JsonKey(name: 'total_hours') int totalHours,@JsonKey(name: 'places_visited') int placesVisited,@JsonKey(name: 'total_points') int totalPoints
});




}
/// @nodoc
class __$PerformanceStatsModelCopyWithImpl<$Res>
    implements _$PerformanceStatsModelCopyWith<$Res> {
  __$PerformanceStatsModelCopyWithImpl(this._self, this._then);

  final _PerformanceStatsModel _self;
  final $Res Function(_PerformanceStatsModel) _then;

/// Create a copy of PerformanceStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatarUrl = null,Object? rating = null,Object? level = null,Object? levelTitle = null,Object? totalHours = null,Object? placesVisited = null,Object? totalPoints = null,}) {
  return _then(_PerformanceStatsModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MonthlyHoursModel {

 int get year; int get month; double get hours;
/// Create a copy of MonthlyHoursModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyHoursModelCopyWith<MonthlyHoursModel> get copyWith => _$MonthlyHoursModelCopyWithImpl<MonthlyHoursModel>(this as MonthlyHoursModel, _$identity);

  /// Serializes this MonthlyHoursModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyHoursModel&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,hours);

@override
String toString() {
  return 'MonthlyHoursModel(year: $year, month: $month, hours: $hours)';
}


}

/// @nodoc
abstract mixin class $MonthlyHoursModelCopyWith<$Res>  {
  factory $MonthlyHoursModelCopyWith(MonthlyHoursModel value, $Res Function(MonthlyHoursModel) _then) = _$MonthlyHoursModelCopyWithImpl;
@useResult
$Res call({
 int year, int month, double hours
});




}
/// @nodoc
class _$MonthlyHoursModelCopyWithImpl<$Res>
    implements $MonthlyHoursModelCopyWith<$Res> {
  _$MonthlyHoursModelCopyWithImpl(this._self, this._then);

  final MonthlyHoursModel _self;
  final $Res Function(MonthlyHoursModel) _then;

/// Create a copy of MonthlyHoursModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? hours = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyHoursModel].
extension MonthlyHoursModelPatterns on MonthlyHoursModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyHoursModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyHoursModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyHoursModel value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyHoursModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyHoursModel value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyHoursModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  double hours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyHoursModel() when $default != null:
return $default(_that.year,_that.month,_that.hours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  double hours)  $default,) {final _that = this;
switch (_that) {
case _MonthlyHoursModel():
return $default(_that.year,_that.month,_that.hours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  double hours)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyHoursModel() when $default != null:
return $default(_that.year,_that.month,_that.hours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyHoursModel implements MonthlyHoursModel {
  const _MonthlyHoursModel({required this.year, required this.month, this.hours = 0.0});
  factory _MonthlyHoursModel.fromJson(Map<String, dynamic> json) => _$MonthlyHoursModelFromJson(json);

@override final  int year;
@override final  int month;
@override@JsonKey() final  double hours;

/// Create a copy of MonthlyHoursModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyHoursModelCopyWith<_MonthlyHoursModel> get copyWith => __$MonthlyHoursModelCopyWithImpl<_MonthlyHoursModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyHoursModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyHoursModel&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,hours);

@override
String toString() {
  return 'MonthlyHoursModel(year: $year, month: $month, hours: $hours)';
}


}

/// @nodoc
abstract mixin class _$MonthlyHoursModelCopyWith<$Res> implements $MonthlyHoursModelCopyWith<$Res> {
  factory _$MonthlyHoursModelCopyWith(_MonthlyHoursModel value, $Res Function(_MonthlyHoursModel) _then) = __$MonthlyHoursModelCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, double hours
});




}
/// @nodoc
class __$MonthlyHoursModelCopyWithImpl<$Res>
    implements _$MonthlyHoursModelCopyWith<$Res> {
  __$MonthlyHoursModelCopyWithImpl(this._self, this._then);

  final _MonthlyHoursModel _self;
  final $Res Function(_MonthlyHoursModel) _then;

/// Create a copy of MonthlyHoursModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? hours = null,}) {
  return _then(_MonthlyHoursModel(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$LeaderboardEntryModel {

 String get id; String get name;@JsonKey(name: 'avatar_url') String get avatarUrl;@JsonKey(name: 'total_hours') int get totalHours; int get pts;
/// Create a copy of LeaderboardEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryModelCopyWith<LeaderboardEntryModel> get copyWith => _$LeaderboardEntryModelCopyWithImpl<LeaderboardEntryModel>(this as LeaderboardEntryModel, _$identity);

  /// Serializes this LeaderboardEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.pts, pts) || other.pts == pts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,totalHours,pts);

@override
String toString() {
  return 'LeaderboardEntryModel(id: $id, name: $name, avatarUrl: $avatarUrl, totalHours: $totalHours, pts: $pts)';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryModelCopyWith<$Res>  {
  factory $LeaderboardEntryModelCopyWith(LeaderboardEntryModel value, $Res Function(LeaderboardEntryModel) _then) = _$LeaderboardEntryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'avatar_url') String avatarUrl,@JsonKey(name: 'total_hours') int totalHours, int pts
});




}
/// @nodoc
class _$LeaderboardEntryModelCopyWithImpl<$Res>
    implements $LeaderboardEntryModelCopyWith<$Res> {
  _$LeaderboardEntryModelCopyWithImpl(this._self, this._then);

  final LeaderboardEntryModel _self;
  final $Res Function(LeaderboardEntryModel) _then;

/// Create a copy of LeaderboardEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = null,Object? totalHours = null,Object? pts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,pts: null == pts ? _self.pts : pts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardEntryModel].
extension LeaderboardEntryModelPatterns on LeaderboardEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'total_hours')  int totalHours,  int pts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntryModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.totalHours,_that.pts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'total_hours')  int totalHours,  int pts)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntryModel():
return $default(_that.id,_that.name,_that.avatarUrl,_that.totalHours,_that.pts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'total_hours')  int totalHours,  int pts)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntryModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.totalHours,_that.pts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardEntryModel implements LeaderboardEntryModel {
  const _LeaderboardEntryModel({required this.id, required this.name, @JsonKey(name: 'avatar_url') this.avatarUrl = '', @JsonKey(name: 'total_hours') this.totalHours = 0, this.pts = 0});
  factory _LeaderboardEntryModel.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;
@override@JsonKey(name: 'total_hours') final  int totalHours;
@override@JsonKey() final  int pts;

/// Create a copy of LeaderboardEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryModelCopyWith<_LeaderboardEntryModel> get copyWith => __$LeaderboardEntryModelCopyWithImpl<_LeaderboardEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.pts, pts) || other.pts == pts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,totalHours,pts);

@override
String toString() {
  return 'LeaderboardEntryModel(id: $id, name: $name, avatarUrl: $avatarUrl, totalHours: $totalHours, pts: $pts)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryModelCopyWith<$Res> implements $LeaderboardEntryModelCopyWith<$Res> {
  factory _$LeaderboardEntryModelCopyWith(_LeaderboardEntryModel value, $Res Function(_LeaderboardEntryModel) _then) = __$LeaderboardEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'avatar_url') String avatarUrl,@JsonKey(name: 'total_hours') int totalHours, int pts
});




}
/// @nodoc
class __$LeaderboardEntryModelCopyWithImpl<$Res>
    implements _$LeaderboardEntryModelCopyWith<$Res> {
  __$LeaderboardEntryModelCopyWithImpl(this._self, this._then);

  final _LeaderboardEntryModel _self;
  final $Res Function(_LeaderboardEntryModel) _then;

/// Create a copy of LeaderboardEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = null,Object? totalHours = null,Object? pts = null,}) {
  return _then(_LeaderboardEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,pts: null == pts ? _self.pts : pts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
