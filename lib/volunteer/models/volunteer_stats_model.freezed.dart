// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'volunteer_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VolunteerStatsModel {

 String get id; String get name; String get email; String get phone; String get role; String get gender;@JsonKey(name: 'avatar_url') String get avatarUrl; String get region; String get qualification; int get level;@JsonKey(name: 'level_title') String get levelTitle; double get rating;@JsonKey(name: 'total_hours') int get totalHours;@JsonKey(name: 'total_tasks') int get totalTasks;@JsonKey(name: 'places_visited') int get placesVisited;
/// Create a copy of VolunteerStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VolunteerStatsModelCopyWith<VolunteerStatsModel> get copyWith => _$VolunteerStatsModelCopyWithImpl<VolunteerStatsModel>(this as VolunteerStatsModel, _$identity);

  /// Serializes this VolunteerStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VolunteerStatsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.region, region) || other.region == region)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,role,gender,avatarUrl,region,qualification,level,levelTitle,rating,totalHours,totalTasks,placesVisited);

@override
String toString() {
  return 'VolunteerStatsModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, gender: $gender, avatarUrl: $avatarUrl, region: $region, qualification: $qualification, level: $level, levelTitle: $levelTitle, rating: $rating, totalHours: $totalHours, totalTasks: $totalTasks, placesVisited: $placesVisited)';
}


}

/// @nodoc
abstract mixin class $VolunteerStatsModelCopyWith<$Res>  {
  factory $VolunteerStatsModelCopyWith(VolunteerStatsModel value, $Res Function(VolunteerStatsModel) _then) = _$VolunteerStatsModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String phone, String role, String gender,@JsonKey(name: 'avatar_url') String avatarUrl, String region, String qualification, int level,@JsonKey(name: 'level_title') String levelTitle, double rating,@JsonKey(name: 'total_hours') int totalHours,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'places_visited') int placesVisited
});




}
/// @nodoc
class _$VolunteerStatsModelCopyWithImpl<$Res>
    implements $VolunteerStatsModelCopyWith<$Res> {
  _$VolunteerStatsModelCopyWithImpl(this._self, this._then);

  final VolunteerStatsModel _self;
  final $Res Function(VolunteerStatsModel) _then;

/// Create a copy of VolunteerStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? role = null,Object? gender = null,Object? avatarUrl = null,Object? region = null,Object? qualification = null,Object? level = null,Object? levelTitle = null,Object? rating = null,Object? totalHours = null,Object? totalTasks = null,Object? placesVisited = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VolunteerStatsModel].
extension VolunteerStatsModelPatterns on VolunteerStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VolunteerStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VolunteerStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VolunteerStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _VolunteerStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VolunteerStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _VolunteerStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone,  String role,  String gender, @JsonKey(name: 'avatar_url')  String avatarUrl,  String region,  String qualification,  int level, @JsonKey(name: 'level_title')  String levelTitle,  double rating, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'places_visited')  int placesVisited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VolunteerStatsModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.gender,_that.avatarUrl,_that.region,_that.qualification,_that.level,_that.levelTitle,_that.rating,_that.totalHours,_that.totalTasks,_that.placesVisited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone,  String role,  String gender, @JsonKey(name: 'avatar_url')  String avatarUrl,  String region,  String qualification,  int level, @JsonKey(name: 'level_title')  String levelTitle,  double rating, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'places_visited')  int placesVisited)  $default,) {final _that = this;
switch (_that) {
case _VolunteerStatsModel():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.gender,_that.avatarUrl,_that.region,_that.qualification,_that.level,_that.levelTitle,_that.rating,_that.totalHours,_that.totalTasks,_that.placesVisited);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String phone,  String role,  String gender, @JsonKey(name: 'avatar_url')  String avatarUrl,  String region,  String qualification,  int level, @JsonKey(name: 'level_title')  String levelTitle,  double rating, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'places_visited')  int placesVisited)?  $default,) {final _that = this;
switch (_that) {
case _VolunteerStatsModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.gender,_that.avatarUrl,_that.region,_that.qualification,_that.level,_that.levelTitle,_that.rating,_that.totalHours,_that.totalTasks,_that.placesVisited);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VolunteerStatsModel implements VolunteerStatsModel {
  const _VolunteerStatsModel({required this.id, required this.name, required this.email, this.phone = '', this.role = '', this.gender = '', @JsonKey(name: 'avatar_url') this.avatarUrl = '', this.region = '', this.qualification = '', this.level = 1, @JsonKey(name: 'level_title') this.levelTitle = 'متطوع جديد', this.rating = 0.0, @JsonKey(name: 'total_hours') this.totalHours = 0, @JsonKey(name: 'total_tasks') this.totalTasks = 0, @JsonKey(name: 'places_visited') this.placesVisited = 0});
  factory _VolunteerStatsModel.fromJson(Map<String, dynamic> json) => _$VolunteerStatsModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String role;
@override@JsonKey() final  String gender;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;
@override@JsonKey() final  String region;
@override@JsonKey() final  String qualification;
@override@JsonKey() final  int level;
@override@JsonKey(name: 'level_title') final  String levelTitle;
@override@JsonKey() final  double rating;
@override@JsonKey(name: 'total_hours') final  int totalHours;
@override@JsonKey(name: 'total_tasks') final  int totalTasks;
@override@JsonKey(name: 'places_visited') final  int placesVisited;

/// Create a copy of VolunteerStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VolunteerStatsModelCopyWith<_VolunteerStatsModel> get copyWith => __$VolunteerStatsModelCopyWithImpl<_VolunteerStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VolunteerStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VolunteerStatsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.region, region) || other.region == region)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,role,gender,avatarUrl,region,qualification,level,levelTitle,rating,totalHours,totalTasks,placesVisited);

@override
String toString() {
  return 'VolunteerStatsModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, gender: $gender, avatarUrl: $avatarUrl, region: $region, qualification: $qualification, level: $level, levelTitle: $levelTitle, rating: $rating, totalHours: $totalHours, totalTasks: $totalTasks, placesVisited: $placesVisited)';
}


}

/// @nodoc
abstract mixin class _$VolunteerStatsModelCopyWith<$Res> implements $VolunteerStatsModelCopyWith<$Res> {
  factory _$VolunteerStatsModelCopyWith(_VolunteerStatsModel value, $Res Function(_VolunteerStatsModel) _then) = __$VolunteerStatsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String phone, String role, String gender,@JsonKey(name: 'avatar_url') String avatarUrl, String region, String qualification, int level,@JsonKey(name: 'level_title') String levelTitle, double rating,@JsonKey(name: 'total_hours') int totalHours,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'places_visited') int placesVisited
});




}
/// @nodoc
class __$VolunteerStatsModelCopyWithImpl<$Res>
    implements _$VolunteerStatsModelCopyWith<$Res> {
  __$VolunteerStatsModelCopyWithImpl(this._self, this._then);

  final _VolunteerStatsModel _self;
  final $Res Function(_VolunteerStatsModel) _then;

/// Create a copy of VolunteerStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? role = null,Object? gender = null,Object? avatarUrl = null,Object? region = null,Object? qualification = null,Object? level = null,Object? levelTitle = null,Object? rating = null,Object? totalHours = null,Object? totalTasks = null,Object? placesVisited = null,}) {
  return _then(_VolunteerStatsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
