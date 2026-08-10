// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'average_speed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AverageSpeedModel {

 String get units; String get speed;
/// Create a copy of AverageSpeedModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AverageSpeedModelCopyWith<AverageSpeedModel> get copyWith => _$AverageSpeedModelCopyWithImpl<AverageSpeedModel>(this as AverageSpeedModel, _$identity);

  /// Serializes this AverageSpeedModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AverageSpeedModel&&(identical(other.units, units) || other.units == units)&&(identical(other.speed, speed) || other.speed == speed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,units,speed);

@override
String toString() {
  return 'AverageSpeedModel(units: $units, speed: $speed)';
}


}

/// @nodoc
abstract mixin class $AverageSpeedModelCopyWith<$Res>  {
  factory $AverageSpeedModelCopyWith(AverageSpeedModel value, $Res Function(AverageSpeedModel) _then) = _$AverageSpeedModelCopyWithImpl;
@useResult
$Res call({
 String units, String speed
});




}
/// @nodoc
class _$AverageSpeedModelCopyWithImpl<$Res>
    implements $AverageSpeedModelCopyWith<$Res> {
  _$AverageSpeedModelCopyWithImpl(this._self, this._then);

  final AverageSpeedModel _self;
  final $Res Function(AverageSpeedModel) _then;

/// Create a copy of AverageSpeedModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? speed = null,}) {
  return _then(_self.copyWith(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AverageSpeedModel].
extension AverageSpeedModelPatterns on AverageSpeedModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AverageSpeedModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AverageSpeedModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AverageSpeedModel value)  $default,){
final _that = this;
switch (_that) {
case _AverageSpeedModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AverageSpeedModel value)?  $default,){
final _that = this;
switch (_that) {
case _AverageSpeedModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String units,  String speed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AverageSpeedModel() when $default != null:
return $default(_that.units,_that.speed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String units,  String speed)  $default,) {final _that = this;
switch (_that) {
case _AverageSpeedModel():
return $default(_that.units,_that.speed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String units,  String speed)?  $default,) {final _that = this;
switch (_that) {
case _AverageSpeedModel() when $default != null:
return $default(_that.units,_that.speed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AverageSpeedModel implements AverageSpeedModel {
  const _AverageSpeedModel({required this.units, required this.speed});
  factory _AverageSpeedModel.fromJson(Map<String, dynamic> json) => _$AverageSpeedModelFromJson(json);

@override final  String units;
@override final  String speed;

/// Create a copy of AverageSpeedModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AverageSpeedModelCopyWith<_AverageSpeedModel> get copyWith => __$AverageSpeedModelCopyWithImpl<_AverageSpeedModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AverageSpeedModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AverageSpeedModel&&(identical(other.units, units) || other.units == units)&&(identical(other.speed, speed) || other.speed == speed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,units,speed);

@override
String toString() {
  return 'AverageSpeedModel(units: $units, speed: $speed)';
}


}

/// @nodoc
abstract mixin class _$AverageSpeedModelCopyWith<$Res> implements $AverageSpeedModelCopyWith<$Res> {
  factory _$AverageSpeedModelCopyWith(_AverageSpeedModel value, $Res Function(_AverageSpeedModel) _then) = __$AverageSpeedModelCopyWithImpl;
@override @useResult
$Res call({
 String units, String speed
});




}
/// @nodoc
class __$AverageSpeedModelCopyWithImpl<$Res>
    implements _$AverageSpeedModelCopyWith<$Res> {
  __$AverageSpeedModelCopyWithImpl(this._self, this._then);

  final _AverageSpeedModel _self;
  final $Res Function(_AverageSpeedModel) _then;

/// Create a copy of AverageSpeedModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? speed = null,}) {
  return _then(_AverageSpeedModel(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
