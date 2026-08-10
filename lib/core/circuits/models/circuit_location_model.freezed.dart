// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circuit_location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircuitLocationModel {

 String get lat; String get long; String get locality; String get country;
/// Create a copy of CircuitLocationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitLocationModelCopyWith<CircuitLocationModel> get copyWith => _$CircuitLocationModelCopyWithImpl<CircuitLocationModel>(this as CircuitLocationModel, _$identity);

  /// Serializes this CircuitLocationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitLocationModel&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.long, long) || other.long == long)&&(identical(other.locality, locality) || other.locality == locality)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,long,locality,country);

@override
String toString() {
  return 'CircuitLocationModel(lat: $lat, long: $long, locality: $locality, country: $country)';
}


}

/// @nodoc
abstract mixin class $CircuitLocationModelCopyWith<$Res>  {
  factory $CircuitLocationModelCopyWith(CircuitLocationModel value, $Res Function(CircuitLocationModel) _then) = _$CircuitLocationModelCopyWithImpl;
@useResult
$Res call({
 String lat, String long, String locality, String country
});




}
/// @nodoc
class _$CircuitLocationModelCopyWithImpl<$Res>
    implements $CircuitLocationModelCopyWith<$Res> {
  _$CircuitLocationModelCopyWithImpl(this._self, this._then);

  final CircuitLocationModel _self;
  final $Res Function(CircuitLocationModel) _then;

/// Create a copy of CircuitLocationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? long = null,Object? locality = null,Object? country = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as String,long: null == long ? _self.long : long // ignore: cast_nullable_to_non_nullable
as String,locality: null == locality ? _self.locality : locality // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CircuitLocationModel].
extension CircuitLocationModelPatterns on CircuitLocationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircuitLocationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircuitLocationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircuitLocationModel value)  $default,){
final _that = this;
switch (_that) {
case _CircuitLocationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircuitLocationModel value)?  $default,){
final _that = this;
switch (_that) {
case _CircuitLocationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lat,  String long,  String locality,  String country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircuitLocationModel() when $default != null:
return $default(_that.lat,_that.long,_that.locality,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lat,  String long,  String locality,  String country)  $default,) {final _that = this;
switch (_that) {
case _CircuitLocationModel():
return $default(_that.lat,_that.long,_that.locality,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lat,  String long,  String locality,  String country)?  $default,) {final _that = this;
switch (_that) {
case _CircuitLocationModel() when $default != null:
return $default(_that.lat,_that.long,_that.locality,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircuitLocationModel implements CircuitLocationModel {
  const _CircuitLocationModel({required this.lat, required this.long, required this.locality, required this.country});
  factory _CircuitLocationModel.fromJson(Map<String, dynamic> json) => _$CircuitLocationModelFromJson(json);

@override final  String lat;
@override final  String long;
@override final  String locality;
@override final  String country;

/// Create a copy of CircuitLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircuitLocationModelCopyWith<_CircuitLocationModel> get copyWith => __$CircuitLocationModelCopyWithImpl<_CircuitLocationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircuitLocationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircuitLocationModel&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.long, long) || other.long == long)&&(identical(other.locality, locality) || other.locality == locality)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,long,locality,country);

@override
String toString() {
  return 'CircuitLocationModel(lat: $lat, long: $long, locality: $locality, country: $country)';
}


}

/// @nodoc
abstract mixin class _$CircuitLocationModelCopyWith<$Res> implements $CircuitLocationModelCopyWith<$Res> {
  factory _$CircuitLocationModelCopyWith(_CircuitLocationModel value, $Res Function(_CircuitLocationModel) _then) = __$CircuitLocationModelCopyWithImpl;
@override @useResult
$Res call({
 String lat, String long, String locality, String country
});




}
/// @nodoc
class __$CircuitLocationModelCopyWithImpl<$Res>
    implements _$CircuitLocationModelCopyWith<$Res> {
  __$CircuitLocationModelCopyWithImpl(this._self, this._then);

  final _CircuitLocationModel _self;
  final $Res Function(_CircuitLocationModel) _then;

/// Create a copy of CircuitLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? long = null,Object? locality = null,Object? country = null,}) {
  return _then(_CircuitLocationModel(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as String,long: null == long ? _self.long : long // ignore: cast_nullable_to_non_nullable
as String,locality: null == locality ? _self.locality : locality // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
