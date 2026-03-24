// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _RegistrationPending value)?  registrationPending,TResult Function( _Error value)?  error,TResult Function( _RoleChanged value)?  roleChanged,TResult Function( _GenderChanged value)?  genderChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _RegistrationPending() when registrationPending != null:
return registrationPending(_that);case _Error() when error != null:
return error(_that);case _RoleChanged() when roleChanged != null:
return roleChanged(_that);case _GenderChanged() when genderChanged != null:
return genderChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _RegistrationPending value)  registrationPending,required TResult Function( _Error value)  error,required TResult Function( _RoleChanged value)  roleChanged,required TResult Function( _GenderChanged value)  genderChanged,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _RegistrationPending():
return registrationPending(_that);case _Error():
return error(_that);case _RoleChanged():
return roleChanged(_that);case _GenderChanged():
return genderChanged(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _RegistrationPending value)?  registrationPending,TResult? Function( _Error value)?  error,TResult? Function( _RoleChanged value)?  roleChanged,TResult? Function( _GenderChanged value)?  genderChanged,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _RegistrationPending() when registrationPending != null:
return registrationPending(_that);case _Error() when error != null:
return error(_that);case _RoleChanged() when roleChanged != null:
return roleChanged(_that);case _GenderChanged() when genderChanged != null:
return genderChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserEntity user)?  success,TResult Function()?  registrationPending,TResult Function( String message)?  error,TResult Function( bool isVolunteer)?  roleChanged,TResult Function( String gender)?  genderChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.user);case _RegistrationPending() when registrationPending != null:
return registrationPending();case _Error() when error != null:
return error(_that.message);case _RoleChanged() when roleChanged != null:
return roleChanged(_that.isVolunteer);case _GenderChanged() when genderChanged != null:
return genderChanged(_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserEntity user)  success,required TResult Function()  registrationPending,required TResult Function( String message)  error,required TResult Function( bool isVolunteer)  roleChanged,required TResult Function( String gender)  genderChanged,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.user);case _RegistrationPending():
return registrationPending();case _Error():
return error(_that.message);case _RoleChanged():
return roleChanged(_that.isVolunteer);case _GenderChanged():
return genderChanged(_that.gender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserEntity user)?  success,TResult? Function()?  registrationPending,TResult? Function( String message)?  error,TResult? Function( bool isVolunteer)?  roleChanged,TResult? Function( String gender)?  genderChanged,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.user);case _RegistrationPending() when registrationPending != null:
return registrationPending();case _Error() when error != null:
return error(_that.message);case _RoleChanged() when roleChanged != null:
return roleChanged(_that.isVolunteer);case _GenderChanged() when genderChanged != null:
return genderChanged(_that.gender);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _Loading implements AuthState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class _Success implements AuthState {
  const _Success(this.user);
  

 final  UserEntity user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.success(user: $user)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_Success(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class _RegistrationPending implements AuthState {
  const _RegistrationPending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationPending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.registrationPending()';
}


}




/// @nodoc


class _Error implements AuthState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RoleChanged implements AuthState {
  const _RoleChanged(this.isVolunteer);
  

 final  bool isVolunteer;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleChangedCopyWith<_RoleChanged> get copyWith => __$RoleChangedCopyWithImpl<_RoleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleChanged&&(identical(other.isVolunteer, isVolunteer) || other.isVolunteer == isVolunteer));
}


@override
int get hashCode => Object.hash(runtimeType,isVolunteer);

@override
String toString() {
  return 'AuthState.roleChanged(isVolunteer: $isVolunteer)';
}


}

/// @nodoc
abstract mixin class _$RoleChangedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$RoleChangedCopyWith(_RoleChanged value, $Res Function(_RoleChanged) _then) = __$RoleChangedCopyWithImpl;
@useResult
$Res call({
 bool isVolunteer
});




}
/// @nodoc
class __$RoleChangedCopyWithImpl<$Res>
    implements _$RoleChangedCopyWith<$Res> {
  __$RoleChangedCopyWithImpl(this._self, this._then);

  final _RoleChanged _self;
  final $Res Function(_RoleChanged) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isVolunteer = null,}) {
  return _then(_RoleChanged(
null == isVolunteer ? _self.isVolunteer : isVolunteer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _GenderChanged implements AuthState {
  const _GenderChanged(this.gender);
  

 final  String gender;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenderChangedCopyWith<_GenderChanged> get copyWith => __$GenderChangedCopyWithImpl<_GenderChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenderChanged&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,gender);

@override
String toString() {
  return 'AuthState.genderChanged(gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$GenderChangedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$GenderChangedCopyWith(_GenderChanged value, $Res Function(_GenderChanged) _then) = __$GenderChangedCopyWithImpl;
@useResult
$Res call({
 String gender
});




}
/// @nodoc
class __$GenderChangedCopyWithImpl<$Res>
    implements _$GenderChangedCopyWith<$Res> {
  __$GenderChangedCopyWithImpl(this._self, this._then);

  final _GenderChanged _self;
  final $Res Function(_GenderChanged) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gender = null,}) {
  return _then(_GenderChanged(
null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
