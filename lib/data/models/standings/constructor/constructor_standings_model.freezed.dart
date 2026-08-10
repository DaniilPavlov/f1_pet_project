// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'constructor_standings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConstructorStandingsModel {

@JsonKey(defaultValue: '') String get position;@JsonKey(defaultValue: '') String get positionText;@JsonKey(defaultValue: '0') String get points;@JsonKey(defaultValue: '0') String get wins;@JsonKey(name: 'Constructor') ConstructorModel get constructor;
/// Create a copy of ConstructorStandingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConstructorStandingsModelCopyWith<ConstructorStandingsModel> get copyWith => _$ConstructorStandingsModelCopyWithImpl<ConstructorStandingsModel>(this as ConstructorStandingsModel, _$identity);

  /// Serializes this ConstructorStandingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConstructorStandingsModel&&(identical(other.position, position) || other.position == position)&&(identical(other.positionText, positionText) || other.positionText == positionText)&&(identical(other.points, points) || other.points == points)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.constructor, constructor) || other.constructor == constructor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,positionText,points,wins,constructor);

@override
String toString() {
  return 'ConstructorStandingsModel(position: $position, positionText: $positionText, points: $points, wins: $wins, constructor: $constructor)';
}


}

/// @nodoc
abstract mixin class $ConstructorStandingsModelCopyWith<$Res>  {
  factory $ConstructorStandingsModelCopyWith(ConstructorStandingsModel value, $Res Function(ConstructorStandingsModel) _then) = _$ConstructorStandingsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String position,@JsonKey(defaultValue: '') String positionText,@JsonKey(defaultValue: '0') String points,@JsonKey(defaultValue: '0') String wins,@JsonKey(name: 'Constructor') ConstructorModel constructor
});


$ConstructorModelCopyWith<$Res> get constructor;

}
/// @nodoc
class _$ConstructorStandingsModelCopyWithImpl<$Res>
    implements $ConstructorStandingsModelCopyWith<$Res> {
  _$ConstructorStandingsModelCopyWithImpl(this._self, this._then);

  final ConstructorStandingsModel _self;
  final $Res Function(ConstructorStandingsModel) _then;

/// Create a copy of ConstructorStandingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? positionText = null,Object? points = null,Object? wins = null,Object? constructor = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,positionText: null == positionText ? _self.positionText : positionText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as String,constructor: null == constructor ? _self.constructor : constructor // ignore: cast_nullable_to_non_nullable
as ConstructorModel,
  ));
}
/// Create a copy of ConstructorStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstructorModelCopyWith<$Res> get constructor {
  
  return $ConstructorModelCopyWith<$Res>(_self.constructor, (value) {
    return _then(_self.copyWith(constructor: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConstructorStandingsModel].
extension ConstructorStandingsModelPatterns on ConstructorStandingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConstructorStandingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConstructorStandingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConstructorStandingsModel value)  $default,){
final _that = this;
switch (_that) {
case _ConstructorStandingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConstructorStandingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConstructorStandingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String position, @JsonKey(defaultValue: '')  String positionText, @JsonKey(defaultValue: '0')  String points, @JsonKey(defaultValue: '0')  String wins, @JsonKey(name: 'Constructor')  ConstructorModel constructor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConstructorStandingsModel() when $default != null:
return $default(_that.position,_that.positionText,_that.points,_that.wins,_that.constructor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String position, @JsonKey(defaultValue: '')  String positionText, @JsonKey(defaultValue: '0')  String points, @JsonKey(defaultValue: '0')  String wins, @JsonKey(name: 'Constructor')  ConstructorModel constructor)  $default,) {final _that = this;
switch (_that) {
case _ConstructorStandingsModel():
return $default(_that.position,_that.positionText,_that.points,_that.wins,_that.constructor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String position, @JsonKey(defaultValue: '')  String positionText, @JsonKey(defaultValue: '0')  String points, @JsonKey(defaultValue: '0')  String wins, @JsonKey(name: 'Constructor')  ConstructorModel constructor)?  $default,) {final _that = this;
switch (_that) {
case _ConstructorStandingsModel() when $default != null:
return $default(_that.position,_that.positionText,_that.points,_that.wins,_that.constructor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConstructorStandingsModel implements ConstructorStandingsModel {
  const _ConstructorStandingsModel({@JsonKey(defaultValue: '') required this.position, @JsonKey(defaultValue: '') required this.positionText, @JsonKey(defaultValue: '0') required this.points, @JsonKey(defaultValue: '0') required this.wins, @JsonKey(name: 'Constructor') required this.constructor});
  factory _ConstructorStandingsModel.fromJson(Map<String, dynamic> json) => _$ConstructorStandingsModelFromJson(json);

@override@JsonKey(defaultValue: '') final  String position;
@override@JsonKey(defaultValue: '') final  String positionText;
@override@JsonKey(defaultValue: '0') final  String points;
@override@JsonKey(defaultValue: '0') final  String wins;
@override@JsonKey(name: 'Constructor') final  ConstructorModel constructor;

/// Create a copy of ConstructorStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConstructorStandingsModelCopyWith<_ConstructorStandingsModel> get copyWith => __$ConstructorStandingsModelCopyWithImpl<_ConstructorStandingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConstructorStandingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConstructorStandingsModel&&(identical(other.position, position) || other.position == position)&&(identical(other.positionText, positionText) || other.positionText == positionText)&&(identical(other.points, points) || other.points == points)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.constructor, constructor) || other.constructor == constructor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,positionText,points,wins,constructor);

@override
String toString() {
  return 'ConstructorStandingsModel(position: $position, positionText: $positionText, points: $points, wins: $wins, constructor: $constructor)';
}


}

/// @nodoc
abstract mixin class _$ConstructorStandingsModelCopyWith<$Res> implements $ConstructorStandingsModelCopyWith<$Res> {
  factory _$ConstructorStandingsModelCopyWith(_ConstructorStandingsModel value, $Res Function(_ConstructorStandingsModel) _then) = __$ConstructorStandingsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String position,@JsonKey(defaultValue: '') String positionText,@JsonKey(defaultValue: '0') String points,@JsonKey(defaultValue: '0') String wins,@JsonKey(name: 'Constructor') ConstructorModel constructor
});


@override $ConstructorModelCopyWith<$Res> get constructor;

}
/// @nodoc
class __$ConstructorStandingsModelCopyWithImpl<$Res>
    implements _$ConstructorStandingsModelCopyWith<$Res> {
  __$ConstructorStandingsModelCopyWithImpl(this._self, this._then);

  final _ConstructorStandingsModel _self;
  final $Res Function(_ConstructorStandingsModel) _then;

/// Create a copy of ConstructorStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? positionText = null,Object? points = null,Object? wins = null,Object? constructor = null,}) {
  return _then(_ConstructorStandingsModel(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,positionText: null == positionText ? _self.positionText : positionText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as String,constructor: null == constructor ? _self.constructor : constructor // ignore: cast_nullable_to_non_nullable
as ConstructorModel,
  ));
}

/// Create a copy of ConstructorStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstructorModelCopyWith<$Res> get constructor {
  
  return $ConstructorModelCopyWith<$Res>(_self.constructor, (value) {
    return _then(_self.copyWith(constructor: value));
  });
}
}

// dart format on
