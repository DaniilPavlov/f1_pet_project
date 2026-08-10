// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_standings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverStandingsModel {

@JsonKey(defaultValue: '') String get position;@JsonKey(defaultValue: '') String get positionText;@JsonKey(defaultValue: '0') String get points;@JsonKey(defaultValue: '0') String get wins;@JsonKey(name: 'Driver') DriverModel get driver;@JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[]) List<ConstructorModel> get constructors;
/// Create a copy of DriverStandingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverStandingsModelCopyWith<DriverStandingsModel> get copyWith => _$DriverStandingsModelCopyWithImpl<DriverStandingsModel>(this as DriverStandingsModel, _$identity);

  /// Serializes this DriverStandingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverStandingsModel&&(identical(other.position, position) || other.position == position)&&(identical(other.positionText, positionText) || other.positionText == positionText)&&(identical(other.points, points) || other.points == points)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.driver, driver) || other.driver == driver)&&const DeepCollectionEquality().equals(other.constructors, constructors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,positionText,points,wins,driver,const DeepCollectionEquality().hash(constructors));

@override
String toString() {
  return 'DriverStandingsModel(position: $position, positionText: $positionText, points: $points, wins: $wins, driver: $driver, constructors: $constructors)';
}


}

/// @nodoc
abstract mixin class $DriverStandingsModelCopyWith<$Res>  {
  factory $DriverStandingsModelCopyWith(DriverStandingsModel value, $Res Function(DriverStandingsModel) _then) = _$DriverStandingsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String position,@JsonKey(defaultValue: '') String positionText,@JsonKey(defaultValue: '0') String points,@JsonKey(defaultValue: '0') String wins,@JsonKey(name: 'Driver') DriverModel driver,@JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[]) List<ConstructorModel> constructors
});


$DriverModelCopyWith<$Res> get driver;

}
/// @nodoc
class _$DriverStandingsModelCopyWithImpl<$Res>
    implements $DriverStandingsModelCopyWith<$Res> {
  _$DriverStandingsModelCopyWithImpl(this._self, this._then);

  final DriverStandingsModel _self;
  final $Res Function(DriverStandingsModel) _then;

/// Create a copy of DriverStandingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? positionText = null,Object? points = null,Object? wins = null,Object? driver = null,Object? constructors = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,positionText: null == positionText ? _self.positionText : positionText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverModel,constructors: null == constructors ? _self.constructors : constructors // ignore: cast_nullable_to_non_nullable
as List<ConstructorModel>,
  ));
}
/// Create a copy of DriverStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverModelCopyWith<$Res> get driver {
  
  return $DriverModelCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// Adds pattern-matching-related methods to [DriverStandingsModel].
extension DriverStandingsModelPatterns on DriverStandingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverStandingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverStandingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverStandingsModel value)  $default,){
final _that = this;
switch (_that) {
case _DriverStandingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverStandingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriverStandingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String position, @JsonKey(defaultValue: '')  String positionText, @JsonKey(defaultValue: '0')  String points, @JsonKey(defaultValue: '0')  String wins, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[])  List<ConstructorModel> constructors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverStandingsModel() when $default != null:
return $default(_that.position,_that.positionText,_that.points,_that.wins,_that.driver,_that.constructors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String position, @JsonKey(defaultValue: '')  String positionText, @JsonKey(defaultValue: '0')  String points, @JsonKey(defaultValue: '0')  String wins, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[])  List<ConstructorModel> constructors)  $default,) {final _that = this;
switch (_that) {
case _DriverStandingsModel():
return $default(_that.position,_that.positionText,_that.points,_that.wins,_that.driver,_that.constructors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String position, @JsonKey(defaultValue: '')  String positionText, @JsonKey(defaultValue: '0')  String points, @JsonKey(defaultValue: '0')  String wins, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[])  List<ConstructorModel> constructors)?  $default,) {final _that = this;
switch (_that) {
case _DriverStandingsModel() when $default != null:
return $default(_that.position,_that.positionText,_that.points,_that.wins,_that.driver,_that.constructors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverStandingsModel implements DriverStandingsModel {
  const _DriverStandingsModel({@JsonKey(defaultValue: '') required this.position, @JsonKey(defaultValue: '') required this.positionText, @JsonKey(defaultValue: '0') required this.points, @JsonKey(defaultValue: '0') required this.wins, @JsonKey(name: 'Driver') required this.driver, @JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[]) required final  List<ConstructorModel> constructors}): _constructors = constructors;
  factory _DriverStandingsModel.fromJson(Map<String, dynamic> json) => _$DriverStandingsModelFromJson(json);

@override@JsonKey(defaultValue: '') final  String position;
@override@JsonKey(defaultValue: '') final  String positionText;
@override@JsonKey(defaultValue: '0') final  String points;
@override@JsonKey(defaultValue: '0') final  String wins;
@override@JsonKey(name: 'Driver') final  DriverModel driver;
 final  List<ConstructorModel> _constructors;
@override@JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[]) List<ConstructorModel> get constructors {
  if (_constructors is EqualUnmodifiableListView) return _constructors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_constructors);
}


/// Create a copy of DriverStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverStandingsModelCopyWith<_DriverStandingsModel> get copyWith => __$DriverStandingsModelCopyWithImpl<_DriverStandingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverStandingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverStandingsModel&&(identical(other.position, position) || other.position == position)&&(identical(other.positionText, positionText) || other.positionText == positionText)&&(identical(other.points, points) || other.points == points)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.driver, driver) || other.driver == driver)&&const DeepCollectionEquality().equals(other._constructors, _constructors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,positionText,points,wins,driver,const DeepCollectionEquality().hash(_constructors));

@override
String toString() {
  return 'DriverStandingsModel(position: $position, positionText: $positionText, points: $points, wins: $wins, driver: $driver, constructors: $constructors)';
}


}

/// @nodoc
abstract mixin class _$DriverStandingsModelCopyWith<$Res> implements $DriverStandingsModelCopyWith<$Res> {
  factory _$DriverStandingsModelCopyWith(_DriverStandingsModel value, $Res Function(_DriverStandingsModel) _then) = __$DriverStandingsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String position,@JsonKey(defaultValue: '') String positionText,@JsonKey(defaultValue: '0') String points,@JsonKey(defaultValue: '0') String wins,@JsonKey(name: 'Driver') DriverModel driver,@JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[]) List<ConstructorModel> constructors
});


@override $DriverModelCopyWith<$Res> get driver;

}
/// @nodoc
class __$DriverStandingsModelCopyWithImpl<$Res>
    implements _$DriverStandingsModelCopyWith<$Res> {
  __$DriverStandingsModelCopyWithImpl(this._self, this._then);

  final _DriverStandingsModel _self;
  final $Res Function(_DriverStandingsModel) _then;

/// Create a copy of DriverStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? positionText = null,Object? points = null,Object? wins = null,Object? driver = null,Object? constructors = null,}) {
  return _then(_DriverStandingsModel(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,positionText: null == positionText ? _self.positionText : positionText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverModel,constructors: null == constructors ? _self._constructors : constructors // ignore: cast_nullable_to_non_nullable
as List<ConstructorModel>,
  ));
}

/// Create a copy of DriverStandingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverModelCopyWith<$Res> get driver {
  
  return $DriverModelCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}

// dart format on
