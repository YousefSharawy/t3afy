// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminHomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminHomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState()';
}


}

/// @nodoc
class $AdminHomeStateCopyWith<$Res>  {
$AdminHomeStateCopyWith(AdminHomeState _, $Res Function(AdminHomeState) __);
}


/// Adds pattern-matching-related methods to [AdminHomeState].
extension AdminHomeStatePatterns on AdminHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,TResult Function( _AnnouncementSending value)?  announcementSending,TResult Function( _AnnouncementSent value)?  announcementSent,TResult Function( _AnnouncementError value)?  announcementError,TResult Function( _ExportingPdf value)?  exportingPdf,TResult Function( _ExportSuccess value)?  exportSuccess,TResult Function( _ExportError value)?  exportError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _AnnouncementSending() when announcementSending != null:
return announcementSending(_that);case _AnnouncementSent() when announcementSent != null:
return announcementSent(_that);case _AnnouncementError() when announcementError != null:
return announcementError(_that);case _ExportingPdf() when exportingPdf != null:
return exportingPdf(_that);case _ExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case _ExportError() when exportError != null:
return exportError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,required TResult Function( _AnnouncementSending value)  announcementSending,required TResult Function( _AnnouncementSent value)  announcementSent,required TResult Function( _AnnouncementError value)  announcementError,required TResult Function( _ExportingPdf value)  exportingPdf,required TResult Function( _ExportSuccess value)  exportSuccess,required TResult Function( _ExportError value)  exportError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _AnnouncementSending():
return announcementSending(_that);case _AnnouncementSent():
return announcementSent(_that);case _AnnouncementError():
return announcementError(_that);case _ExportingPdf():
return exportingPdf(_that);case _ExportSuccess():
return exportSuccess(_that);case _ExportError():
return exportError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,TResult? Function( _AnnouncementSending value)?  announcementSending,TResult? Function( _AnnouncementSent value)?  announcementSent,TResult? Function( _AnnouncementError value)?  announcementError,TResult? Function( _ExportingPdf value)?  exportingPdf,TResult? Function( _ExportSuccess value)?  exportSuccess,TResult? Function( _ExportError value)?  exportError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _AnnouncementSending() when announcementSending != null:
return announcementSending(_that);case _AnnouncementSent() when announcementSent != null:
return announcementSent(_that);case _AnnouncementError() when announcementError != null:
return announcementError(_that);case _ExportingPdf() when exportingPdf != null:
return exportingPdf(_that);case _ExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case _ExportError() when exportError != null:
return exportError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AdminHomeDataEntity data)?  loaded,TResult Function( String message)?  error,TResult Function()?  announcementSending,TResult Function()?  announcementSent,TResult Function( String message)?  announcementError,TResult Function()?  exportingPdf,TResult Function()?  exportSuccess,TResult Function( String message)?  exportError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.data);case _Error() when error != null:
return error(_that.message);case _AnnouncementSending() when announcementSending != null:
return announcementSending();case _AnnouncementSent() when announcementSent != null:
return announcementSent();case _AnnouncementError() when announcementError != null:
return announcementError(_that.message);case _ExportingPdf() when exportingPdf != null:
return exportingPdf();case _ExportSuccess() when exportSuccess != null:
return exportSuccess();case _ExportError() when exportError != null:
return exportError(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AdminHomeDataEntity data)  loaded,required TResult Function( String message)  error,required TResult Function()  announcementSending,required TResult Function()  announcementSent,required TResult Function( String message)  announcementError,required TResult Function()  exportingPdf,required TResult Function()  exportSuccess,required TResult Function( String message)  exportError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.data);case _Error():
return error(_that.message);case _AnnouncementSending():
return announcementSending();case _AnnouncementSent():
return announcementSent();case _AnnouncementError():
return announcementError(_that.message);case _ExportingPdf():
return exportingPdf();case _ExportSuccess():
return exportSuccess();case _ExportError():
return exportError(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AdminHomeDataEntity data)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  announcementSending,TResult? Function()?  announcementSent,TResult? Function( String message)?  announcementError,TResult? Function()?  exportingPdf,TResult? Function()?  exportSuccess,TResult? Function( String message)?  exportError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.data);case _Error() when error != null:
return error(_that.message);case _AnnouncementSending() when announcementSending != null:
return announcementSending();case _AnnouncementSent() when announcementSent != null:
return announcementSent();case _AnnouncementError() when announcementError != null:
return announcementError(_that.message);case _ExportingPdf() when exportingPdf != null:
return exportingPdf();case _ExportSuccess() when exportSuccess != null:
return exportSuccess();case _ExportError() when exportError != null:
return exportError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AdminHomeState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState.initial()';
}


}




/// @nodoc


class _Loading implements AdminHomeState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState.loading()';
}


}




/// @nodoc


class _Loaded implements AdminHomeState {
  const _Loaded(this.data);
  

 final  AdminHomeDataEntity data;

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'AdminHomeState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $AdminHomeStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 AdminHomeDataEntity data
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_Loaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdminHomeDataEntity,
  ));
}


}

/// @nodoc


class _Error implements AdminHomeState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of AdminHomeState
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
  return 'AdminHomeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AdminHomeStateCopyWith<$Res> {
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

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AnnouncementSending implements AdminHomeState {
  const _AnnouncementSending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementSending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState.announcementSending()';
}


}




/// @nodoc


class _AnnouncementSent implements AdminHomeState {
  const _AnnouncementSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState.announcementSent()';
}


}




/// @nodoc


class _AnnouncementError implements AdminHomeState {
  const _AnnouncementError(this.message);
  

 final  String message;

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementErrorCopyWith<_AnnouncementError> get copyWith => __$AnnouncementErrorCopyWithImpl<_AnnouncementError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AdminHomeState.announcementError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementErrorCopyWith<$Res> implements $AdminHomeStateCopyWith<$Res> {
  factory _$AnnouncementErrorCopyWith(_AnnouncementError value, $Res Function(_AnnouncementError) _then) = __$AnnouncementErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AnnouncementErrorCopyWithImpl<$Res>
    implements _$AnnouncementErrorCopyWith<$Res> {
  __$AnnouncementErrorCopyWithImpl(this._self, this._then);

  final _AnnouncementError _self;
  final $Res Function(_AnnouncementError) _then;

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AnnouncementError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ExportingPdf implements AdminHomeState {
  const _ExportingPdf();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportingPdf);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState.exportingPdf()';
}


}




/// @nodoc


class _ExportSuccess implements AdminHomeState {
  const _ExportSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminHomeState.exportSuccess()';
}


}




/// @nodoc


class _ExportError implements AdminHomeState {
  const _ExportError(this.message);
  

 final  String message;

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportErrorCopyWith<_ExportError> get copyWith => __$ExportErrorCopyWithImpl<_ExportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AdminHomeState.exportError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ExportErrorCopyWith<$Res> implements $AdminHomeStateCopyWith<$Res> {
  factory _$ExportErrorCopyWith(_ExportError value, $Res Function(_ExportError) _then) = __$ExportErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ExportErrorCopyWithImpl<$Res>
    implements _$ExportErrorCopyWith<$Res> {
  __$ExportErrorCopyWithImpl(this._self, this._then);

  final _ExportError _self;
  final $Res Function(_ExportError) _then;

/// Create a copy of AdminHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ExportError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
