// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResultsModel {

 String get number; String get position; String get positionText; String get points;@JsonKey(name: 'Driver') DriverModel get driver;@JsonKey(name: 'Constructor') ConstructorModel get constructor; String get grid; String get laps; String get status;@JsonKey(name: 'Time') TimeModel? get time;@JsonKey(name: 'FastestLap') FastestLapModel? get fastestLap;
/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultsModelCopyWith<ResultsModel> get copyWith => _$ResultsModelCopyWithImpl<ResultsModel>(this as ResultsModel, _$identity);

  /// Serializes this ResultsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultsModel&&(identical(other.number, number) || other.number == number)&&(identical(other.position, position) || other.position == position)&&(identical(other.positionText, positionText) || other.positionText == positionText)&&(identical(other.points, points) || other.points == points)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.constructor, constructor) || other.constructor == constructor)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.laps, laps) || other.laps == laps)&&(identical(other.status, status) || other.status == status)&&(identical(other.time, time) || other.time == time)&&(identical(other.fastestLap, fastestLap) || other.fastestLap == fastestLap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,position,positionText,points,driver,constructor,grid,laps,status,time,fastestLap);

@override
String toString() {
  return 'ResultsModel(number: $number, position: $position, positionText: $positionText, points: $points, driver: $driver, constructor: $constructor, grid: $grid, laps: $laps, status: $status, time: $time, fastestLap: $fastestLap)';
}


}

/// @nodoc
abstract mixin class $ResultsModelCopyWith<$Res>  {
  factory $ResultsModelCopyWith(ResultsModel value, $Res Function(ResultsModel) _then) = _$ResultsModelCopyWithImpl;
@useResult
$Res call({
 String number, String position, String positionText, String points,@JsonKey(name: 'Driver') DriverModel driver,@JsonKey(name: 'Constructor') ConstructorModel constructor, String grid, String laps, String status,@JsonKey(name: 'Time') TimeModel? time,@JsonKey(name: 'FastestLap') FastestLapModel? fastestLap
});


$DriverModelCopyWith<$Res> get driver;$ConstructorModelCopyWith<$Res> get constructor;$TimeModelCopyWith<$Res>? get time;$FastestLapModelCopyWith<$Res>? get fastestLap;

}
/// @nodoc
class _$ResultsModelCopyWithImpl<$Res>
    implements $ResultsModelCopyWith<$Res> {
  _$ResultsModelCopyWithImpl(this._self, this._then);

  final ResultsModel _self;
  final $Res Function(ResultsModel) _then;

/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? position = null,Object? positionText = null,Object? points = null,Object? driver = null,Object? constructor = null,Object? grid = null,Object? laps = null,Object? status = null,Object? time = freezed,Object? fastestLap = freezed,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,positionText: null == positionText ? _self.positionText : positionText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverModel,constructor: null == constructor ? _self.constructor : constructor // ignore: cast_nullable_to_non_nullable
as ConstructorModel,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as String,laps: null == laps ? _self.laps : laps // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeModel?,fastestLap: freezed == fastestLap ? _self.fastestLap : fastestLap // ignore: cast_nullable_to_non_nullable
as FastestLapModel?,
  ));
}
/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverModelCopyWith<$Res> get driver {
  
  return $DriverModelCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstructorModelCopyWith<$Res> get constructor {
  
  return $ConstructorModelCopyWith<$Res>(_self.constructor, (value) {
    return _then(_self.copyWith(constructor: value));
  });
}/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeModelCopyWith<$Res>? get time {
    if (_self.time == null) {
    return null;
  }

  return $TimeModelCopyWith<$Res>(_self.time!, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FastestLapModelCopyWith<$Res>? get fastestLap {
    if (_self.fastestLap == null) {
    return null;
  }

  return $FastestLapModelCopyWith<$Res>(_self.fastestLap!, (value) {
    return _then(_self.copyWith(fastestLap: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResultsModel].
extension ResultsModelPatterns on ResultsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultsModel value)  $default,){
final _that = this;
switch (_that) {
case _ResultsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResultsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String number,  String position,  String positionText,  String points, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructor')  ConstructorModel constructor,  String grid,  String laps,  String status, @JsonKey(name: 'Time')  TimeModel? time, @JsonKey(name: 'FastestLap')  FastestLapModel? fastestLap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultsModel() when $default != null:
return $default(_that.number,_that.position,_that.positionText,_that.points,_that.driver,_that.constructor,_that.grid,_that.laps,_that.status,_that.time,_that.fastestLap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String number,  String position,  String positionText,  String points, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructor')  ConstructorModel constructor,  String grid,  String laps,  String status, @JsonKey(name: 'Time')  TimeModel? time, @JsonKey(name: 'FastestLap')  FastestLapModel? fastestLap)  $default,) {final _that = this;
switch (_that) {
case _ResultsModel():
return $default(_that.number,_that.position,_that.positionText,_that.points,_that.driver,_that.constructor,_that.grid,_that.laps,_that.status,_that.time,_that.fastestLap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String number,  String position,  String positionText,  String points, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructor')  ConstructorModel constructor,  String grid,  String laps,  String status, @JsonKey(name: 'Time')  TimeModel? time, @JsonKey(name: 'FastestLap')  FastestLapModel? fastestLap)?  $default,) {final _that = this;
switch (_that) {
case _ResultsModel() when $default != null:
return $default(_that.number,_that.position,_that.positionText,_that.points,_that.driver,_that.constructor,_that.grid,_that.laps,_that.status,_that.time,_that.fastestLap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResultsModel extends ResultsModel {
  const _ResultsModel({required this.number, required this.position, required this.positionText, required this.points, @JsonKey(name: 'Driver') required this.driver, @JsonKey(name: 'Constructor') required this.constructor, required this.grid, required this.laps, required this.status, @JsonKey(name: 'Time') this.time, @JsonKey(name: 'FastestLap') this.fastestLap}): super._();
  factory _ResultsModel.fromJson(Map<String, dynamic> json) => _$ResultsModelFromJson(json);

@override final  String number;
@override final  String position;
@override final  String positionText;
@override final  String points;
@override@JsonKey(name: 'Driver') final  DriverModel driver;
@override@JsonKey(name: 'Constructor') final  ConstructorModel constructor;
@override final  String grid;
@override final  String laps;
@override final  String status;
@override@JsonKey(name: 'Time') final  TimeModel? time;
@override@JsonKey(name: 'FastestLap') final  FastestLapModel? fastestLap;

/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultsModelCopyWith<_ResultsModel> get copyWith => __$ResultsModelCopyWithImpl<_ResultsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResultsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultsModel&&(identical(other.number, number) || other.number == number)&&(identical(other.position, position) || other.position == position)&&(identical(other.positionText, positionText) || other.positionText == positionText)&&(identical(other.points, points) || other.points == points)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.constructor, constructor) || other.constructor == constructor)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.laps, laps) || other.laps == laps)&&(identical(other.status, status) || other.status == status)&&(identical(other.time, time) || other.time == time)&&(identical(other.fastestLap, fastestLap) || other.fastestLap == fastestLap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,position,positionText,points,driver,constructor,grid,laps,status,time,fastestLap);

@override
String toString() {
  return 'ResultsModel(number: $number, position: $position, positionText: $positionText, points: $points, driver: $driver, constructor: $constructor, grid: $grid, laps: $laps, status: $status, time: $time, fastestLap: $fastestLap)';
}


}

/// @nodoc
abstract mixin class _$ResultsModelCopyWith<$Res> implements $ResultsModelCopyWith<$Res> {
  factory _$ResultsModelCopyWith(_ResultsModel value, $Res Function(_ResultsModel) _then) = __$ResultsModelCopyWithImpl;
@override @useResult
$Res call({
 String number, String position, String positionText, String points,@JsonKey(name: 'Driver') DriverModel driver,@JsonKey(name: 'Constructor') ConstructorModel constructor, String grid, String laps, String status,@JsonKey(name: 'Time') TimeModel? time,@JsonKey(name: 'FastestLap') FastestLapModel? fastestLap
});


@override $DriverModelCopyWith<$Res> get driver;@override $ConstructorModelCopyWith<$Res> get constructor;@override $TimeModelCopyWith<$Res>? get time;@override $FastestLapModelCopyWith<$Res>? get fastestLap;

}
/// @nodoc
class __$ResultsModelCopyWithImpl<$Res>
    implements _$ResultsModelCopyWith<$Res> {
  __$ResultsModelCopyWithImpl(this._self, this._then);

  final _ResultsModel _self;
  final $Res Function(_ResultsModel) _then;

/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? position = null,Object? positionText = null,Object? points = null,Object? driver = null,Object? constructor = null,Object? grid = null,Object? laps = null,Object? status = null,Object? time = freezed,Object? fastestLap = freezed,}) {
  return _then(_ResultsModel(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,positionText: null == positionText ? _self.positionText : positionText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverModel,constructor: null == constructor ? _self.constructor : constructor // ignore: cast_nullable_to_non_nullable
as ConstructorModel,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as String,laps: null == laps ? _self.laps : laps // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeModel?,fastestLap: freezed == fastestLap ? _self.fastestLap : fastestLap // ignore: cast_nullable_to_non_nullable
as FastestLapModel?,
  ));
}

/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverModelCopyWith<$Res> get driver {
  
  return $DriverModelCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstructorModelCopyWith<$Res> get constructor {
  
  return $ConstructorModelCopyWith<$Res>(_self.constructor, (value) {
    return _then(_self.copyWith(constructor: value));
  });
}/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeModelCopyWith<$Res>? get time {
    if (_self.time == null) {
    return null;
  }

  return $TimeModelCopyWith<$Res>(_self.time!, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of ResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FastestLapModelCopyWith<$Res>? get fastestLap {
    if (_self.fastestLap == null) {
    return null;
  }

  return $FastestLapModelCopyWith<$Res>(_self.fastestLap!, (value) {
    return _then(_self.copyWith(fastestLap: value));
  });
}
}

// dart format on
