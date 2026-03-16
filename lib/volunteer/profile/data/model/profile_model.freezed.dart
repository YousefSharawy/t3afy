// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {

 String get id; String get name; String get email; String get phone;@JsonKey(name: 'avatar_url') String get avatarUrl; String get region; String get qualification; int get level;@JsonKey(name: 'level_title') String get levelTitle; double get rating;@JsonKey(name: 'total_hours') int get totalHours;@JsonKey(name: 'total_tasks') int get totalTasks;@JsonKey(name: 'places_visited') int get placesVisited;@JsonKey(name: 'total_points') int get totalPoints;@JsonKey(name: 'joined_at') String get joinedAt;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.region, region) || other.region == region)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,avatarUrl,region,qualification,level,levelTitle,rating,totalHours,totalTasks,placesVisited,totalPoints,joinedAt);

@override
String toString() {
  return 'ProfileModel(id: $id, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, region: $region, qualification: $qualification, level: $level, levelTitle: $levelTitle, rating: $rating, totalHours: $totalHours, totalTasks: $totalTasks, placesVisited: $placesVisited, totalPoints: $totalPoints, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String phone,@JsonKey(name: 'avatar_url') String avatarUrl, String region, String qualification, int level,@JsonKey(name: 'level_title') String levelTitle, double rating,@JsonKey(name: 'total_hours') int totalHours,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'places_visited') int placesVisited,@JsonKey(name: 'total_points') int totalPoints,@JsonKey(name: 'joined_at') String joinedAt
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? avatarUrl = null,Object? region = null,Object? qualification = null,Object? level = null,Object? levelTitle = null,Object? rating = null,Object? totalHours = null,Object? totalTasks = null,Object? placesVisited = null,Object? totalPoints = null,Object? joinedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone, @JsonKey(name: 'avatar_url')  String avatarUrl,  String region,  String qualification,  int level, @JsonKey(name: 'level_title')  String levelTitle,  double rating, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'places_visited')  int placesVisited, @JsonKey(name: 'total_points')  int totalPoints, @JsonKey(name: 'joined_at')  String joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.region,_that.qualification,_that.level,_that.levelTitle,_that.rating,_that.totalHours,_that.totalTasks,_that.placesVisited,_that.totalPoints,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone, @JsonKey(name: 'avatar_url')  String avatarUrl,  String region,  String qualification,  int level, @JsonKey(name: 'level_title')  String levelTitle,  double rating, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'places_visited')  int placesVisited, @JsonKey(name: 'total_points')  int totalPoints, @JsonKey(name: 'joined_at')  String joinedAt)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.region,_that.qualification,_that.level,_that.levelTitle,_that.rating,_that.totalHours,_that.totalTasks,_that.placesVisited,_that.totalPoints,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String phone, @JsonKey(name: 'avatar_url')  String avatarUrl,  String region,  String qualification,  int level, @JsonKey(name: 'level_title')  String levelTitle,  double rating, @JsonKey(name: 'total_hours')  int totalHours, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'places_visited')  int placesVisited, @JsonKey(name: 'total_points')  int totalPoints, @JsonKey(name: 'joined_at')  String joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.region,_that.qualification,_that.level,_that.levelTitle,_that.rating,_that.totalHours,_that.totalTasks,_that.placesVisited,_that.totalPoints,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileModel implements ProfileModel {
  const _ProfileModel({required this.id, required this.name, required this.email, this.phone = '', @JsonKey(name: 'avatar_url') this.avatarUrl = '', this.region = '', this.qualification = '', this.level = 1, @JsonKey(name: 'level_title') this.levelTitle = 'متطوع جديد', this.rating = 0.0, @JsonKey(name: 'total_hours') this.totalHours = 0, @JsonKey(name: 'total_tasks') this.totalTasks = 0, @JsonKey(name: 'places_visited') this.placesVisited = 0, @JsonKey(name: 'total_points') this.totalPoints = 0, @JsonKey(name: 'joined_at') this.joinedAt = ''});
  factory _ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;
@override@JsonKey() final  String region;
@override@JsonKey() final  String qualification;
@override@JsonKey() final  int level;
@override@JsonKey(name: 'level_title') final  String levelTitle;
@override@JsonKey() final  double rating;
@override@JsonKey(name: 'total_hours') final  int totalHours;
@override@JsonKey(name: 'total_tasks') final  int totalTasks;
@override@JsonKey(name: 'places_visited') final  int placesVisited;
@override@JsonKey(name: 'total_points') final  int totalPoints;
@override@JsonKey(name: 'joined_at') final  String joinedAt;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.region, region) || other.region == region)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,avatarUrl,region,qualification,level,levelTitle,rating,totalHours,totalTasks,placesVisited,totalPoints,joinedAt);

@override
String toString() {
  return 'ProfileModel(id: $id, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, region: $region, qualification: $qualification, level: $level, levelTitle: $levelTitle, rating: $rating, totalHours: $totalHours, totalTasks: $totalTasks, placesVisited: $placesVisited, totalPoints: $totalPoints, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String phone,@JsonKey(name: 'avatar_url') String avatarUrl, String region, String qualification, int level,@JsonKey(name: 'level_title') String levelTitle, double rating,@JsonKey(name: 'total_hours') int totalHours,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'places_visited') int placesVisited,@JsonKey(name: 'total_points') int totalPoints,@JsonKey(name: 'joined_at') String joinedAt
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? avatarUrl = null,Object? region = null,Object? qualification = null,Object? level = null,Object? levelTitle = null,Object? rating = null,Object? totalHours = null,Object? totalTasks = null,Object? placesVisited = null,Object? totalPoints = null,Object? joinedAt = null,}) {
  return _then(_ProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
