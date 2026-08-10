// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverModel {

 String get driverId;/// У старых пилотов в Jolpica иногда нет url / dateOfBirth / nationality —
/// в модели остаётся пустая строка, в UI показывается l10n.unknown.
@JsonKey(defaultValue: '') String get url; String get givenName; String get familyName;@JsonKey(defaultValue: '') String get dateOfBirth;@JsonKey(defaultValue: '') String get nationality; String? get permanentNumber; String? get code;
/// Create a copy of DriverModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverModelCopyWith<DriverModel> get copyWith => _$DriverModelCopyWithImpl<DriverModel>(this as DriverModel, _$identity);

  /// Serializes this DriverModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverModel&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.url, url) || other.url == url)&&(identical(other.givenName, givenName) || other.givenName == givenName)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.permanentNumber, permanentNumber) || other.permanentNumber == permanentNumber)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverId,url,givenName,familyName,dateOfBirth,nationality,permanentNumber,code);

@override
String toString() {
  return 'DriverModel(driverId: $driverId, url: $url, givenName: $givenName, familyName: $familyName, dateOfBirth: $dateOfBirth, nationality: $nationality, permanentNumber: $permanentNumber, code: $code)';
}


}

/// @nodoc
abstract mixin class $DriverModelCopyWith<$Res>  {
  factory $DriverModelCopyWith(DriverModel value, $Res Function(DriverModel) _then) = _$DriverModelCopyWithImpl;
@useResult
$Res call({
 String driverId,@JsonKey(defaultValue: '') String url, String givenName, String familyName,@JsonKey(defaultValue: '') String dateOfBirth,@JsonKey(defaultValue: '') String nationality, String? permanentNumber, String? code
});




}
/// @nodoc
class _$DriverModelCopyWithImpl<$Res>
    implements $DriverModelCopyWith<$Res> {
  _$DriverModelCopyWithImpl(this._self, this._then);

  final DriverModel _self;
  final $Res Function(DriverModel) _then;

/// Create a copy of DriverModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? driverId = null,Object? url = null,Object? givenName = null,Object? familyName = null,Object? dateOfBirth = null,Object? nationality = null,Object? permanentNumber = freezed,Object? code = freezed,}) {
  return _then(_self.copyWith(
driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,permanentNumber: freezed == permanentNumber ? _self.permanentNumber : permanentNumber // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverModel].
extension DriverModelPatterns on DriverModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverModel value)  $default,){
final _that = this;
switch (_that) {
case _DriverModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriverModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String driverId, @JsonKey(defaultValue: '')  String url,  String givenName,  String familyName, @JsonKey(defaultValue: '')  String dateOfBirth, @JsonKey(defaultValue: '')  String nationality,  String? permanentNumber,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverModel() when $default != null:
return $default(_that.driverId,_that.url,_that.givenName,_that.familyName,_that.dateOfBirth,_that.nationality,_that.permanentNumber,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String driverId, @JsonKey(defaultValue: '')  String url,  String givenName,  String familyName, @JsonKey(defaultValue: '')  String dateOfBirth, @JsonKey(defaultValue: '')  String nationality,  String? permanentNumber,  String? code)  $default,) {final _that = this;
switch (_that) {
case _DriverModel():
return $default(_that.driverId,_that.url,_that.givenName,_that.familyName,_that.dateOfBirth,_that.nationality,_that.permanentNumber,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String driverId, @JsonKey(defaultValue: '')  String url,  String givenName,  String familyName, @JsonKey(defaultValue: '')  String dateOfBirth, @JsonKey(defaultValue: '')  String nationality,  String? permanentNumber,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _DriverModel() when $default != null:
return $default(_that.driverId,_that.url,_that.givenName,_that.familyName,_that.dateOfBirth,_that.nationality,_that.permanentNumber,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverModel implements DriverModel {
  const _DriverModel({required this.driverId, @JsonKey(defaultValue: '') required this.url, required this.givenName, required this.familyName, @JsonKey(defaultValue: '') required this.dateOfBirth, @JsonKey(defaultValue: '') required this.nationality, this.permanentNumber, this.code});
  factory _DriverModel.fromJson(Map<String, dynamic> json) => _$DriverModelFromJson(json);

@override final  String driverId;
/// У старых пилотов в Jolpica иногда нет url / dateOfBirth / nationality —
/// в модели остаётся пустая строка, в UI показывается l10n.unknown.
@override@JsonKey(defaultValue: '') final  String url;
@override final  String givenName;
@override final  String familyName;
@override@JsonKey(defaultValue: '') final  String dateOfBirth;
@override@JsonKey(defaultValue: '') final  String nationality;
@override final  String? permanentNumber;
@override final  String? code;

/// Create a copy of DriverModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverModelCopyWith<_DriverModel> get copyWith => __$DriverModelCopyWithImpl<_DriverModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverModel&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.url, url) || other.url == url)&&(identical(other.givenName, givenName) || other.givenName == givenName)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.permanentNumber, permanentNumber) || other.permanentNumber == permanentNumber)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverId,url,givenName,familyName,dateOfBirth,nationality,permanentNumber,code);

@override
String toString() {
  return 'DriverModel(driverId: $driverId, url: $url, givenName: $givenName, familyName: $familyName, dateOfBirth: $dateOfBirth, nationality: $nationality, permanentNumber: $permanentNumber, code: $code)';
}


}

/// @nodoc
abstract mixin class _$DriverModelCopyWith<$Res> implements $DriverModelCopyWith<$Res> {
  factory _$DriverModelCopyWith(_DriverModel value, $Res Function(_DriverModel) _then) = __$DriverModelCopyWithImpl;
@override @useResult
$Res call({
 String driverId,@JsonKey(defaultValue: '') String url, String givenName, String familyName,@JsonKey(defaultValue: '') String dateOfBirth,@JsonKey(defaultValue: '') String nationality, String? permanentNumber, String? code
});




}
/// @nodoc
class __$DriverModelCopyWithImpl<$Res>
    implements _$DriverModelCopyWith<$Res> {
  __$DriverModelCopyWithImpl(this._self, this._then);

  final _DriverModel _self;
  final $Res Function(_DriverModel) _then;

/// Create a copy of DriverModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? driverId = null,Object? url = null,Object? givenName = null,Object? familyName = null,Object? dateOfBirth = null,Object? nationality = null,Object? permanentNumber = freezed,Object? code = freezed,}) {
  return _then(_DriverModel(
driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,permanentNumber: freezed == permanentNumber ? _self.permanentNumber : permanentNumber // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
