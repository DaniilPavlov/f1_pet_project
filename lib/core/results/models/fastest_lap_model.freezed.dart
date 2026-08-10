// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fastest_lap_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FastestLapModel {

 String get rank; String get lap;@JsonKey(name: 'Time') TimeModel get time;@JsonKey(name: 'AverageSpeed') AverageSpeedModel? get averageSpeed;
/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FastestLapModelCopyWith<FastestLapModel> get copyWith => _$FastestLapModelCopyWithImpl<FastestLapModel>(this as FastestLapModel, _$identity);

  /// Serializes this FastestLapModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FastestLapModel&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.lap, lap) || other.lap == lap)&&(identical(other.time, time) || other.time == time)&&(identical(other.averageSpeed, averageSpeed) || other.averageSpeed == averageSpeed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,lap,time,averageSpeed);

@override
String toString() {
  return 'FastestLapModel(rank: $rank, lap: $lap, time: $time, averageSpeed: $averageSpeed)';
}


}

/// @nodoc
abstract mixin class $FastestLapModelCopyWith<$Res>  {
  factory $FastestLapModelCopyWith(FastestLapModel value, $Res Function(FastestLapModel) _then) = _$FastestLapModelCopyWithImpl;
@useResult
$Res call({
 String rank, String lap,@JsonKey(name: 'Time') TimeModel time,@JsonKey(name: 'AverageSpeed') AverageSpeedModel? averageSpeed
});


$TimeModelCopyWith<$Res> get time;$AverageSpeedModelCopyWith<$Res>? get averageSpeed;

}
/// @nodoc
class _$FastestLapModelCopyWithImpl<$Res>
    implements $FastestLapModelCopyWith<$Res> {
  _$FastestLapModelCopyWithImpl(this._self, this._then);

  final FastestLapModel _self;
  final $Res Function(FastestLapModel) _then;

/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? lap = null,Object? time = null,Object? averageSpeed = freezed,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as String,lap: null == lap ? _self.lap : lap // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeModel,averageSpeed: freezed == averageSpeed ? _self.averageSpeed : averageSpeed // ignore: cast_nullable_to_non_nullable
as AverageSpeedModel?,
  ));
}
/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeModelCopyWith<$Res> get time {
  
  return $TimeModelCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AverageSpeedModelCopyWith<$Res>? get averageSpeed {
    if (_self.averageSpeed == null) {
    return null;
  }

  return $AverageSpeedModelCopyWith<$Res>(_self.averageSpeed!, (value) {
    return _then(_self.copyWith(averageSpeed: value));
  });
}
}


/// Adds pattern-matching-related methods to [FastestLapModel].
extension FastestLapModelPatterns on FastestLapModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FastestLapModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FastestLapModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FastestLapModel value)  $default,){
final _that = this;
switch (_that) {
case _FastestLapModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FastestLapModel value)?  $default,){
final _that = this;
switch (_that) {
case _FastestLapModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rank,  String lap, @JsonKey(name: 'Time')  TimeModel time, @JsonKey(name: 'AverageSpeed')  AverageSpeedModel? averageSpeed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FastestLapModel() when $default != null:
return $default(_that.rank,_that.lap,_that.time,_that.averageSpeed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rank,  String lap, @JsonKey(name: 'Time')  TimeModel time, @JsonKey(name: 'AverageSpeed')  AverageSpeedModel? averageSpeed)  $default,) {final _that = this;
switch (_that) {
case _FastestLapModel():
return $default(_that.rank,_that.lap,_that.time,_that.averageSpeed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rank,  String lap, @JsonKey(name: 'Time')  TimeModel time, @JsonKey(name: 'AverageSpeed')  AverageSpeedModel? averageSpeed)?  $default,) {final _that = this;
switch (_that) {
case _FastestLapModel() when $default != null:
return $default(_that.rank,_that.lap,_that.time,_that.averageSpeed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FastestLapModel implements FastestLapModel {
  const _FastestLapModel({required this.rank, required this.lap, @JsonKey(name: 'Time') required this.time, @JsonKey(name: 'AverageSpeed') this.averageSpeed});
  factory _FastestLapModel.fromJson(Map<String, dynamic> json) => _$FastestLapModelFromJson(json);

@override final  String rank;
@override final  String lap;
@override@JsonKey(name: 'Time') final  TimeModel time;
@override@JsonKey(name: 'AverageSpeed') final  AverageSpeedModel? averageSpeed;

/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FastestLapModelCopyWith<_FastestLapModel> get copyWith => __$FastestLapModelCopyWithImpl<_FastestLapModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FastestLapModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FastestLapModel&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.lap, lap) || other.lap == lap)&&(identical(other.time, time) || other.time == time)&&(identical(other.averageSpeed, averageSpeed) || other.averageSpeed == averageSpeed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,lap,time,averageSpeed);

@override
String toString() {
  return 'FastestLapModel(rank: $rank, lap: $lap, time: $time, averageSpeed: $averageSpeed)';
}


}

/// @nodoc
abstract mixin class _$FastestLapModelCopyWith<$Res> implements $FastestLapModelCopyWith<$Res> {
  factory _$FastestLapModelCopyWith(_FastestLapModel value, $Res Function(_FastestLapModel) _then) = __$FastestLapModelCopyWithImpl;
@override @useResult
$Res call({
 String rank, String lap,@JsonKey(name: 'Time') TimeModel time,@JsonKey(name: 'AverageSpeed') AverageSpeedModel? averageSpeed
});


@override $TimeModelCopyWith<$Res> get time;@override $AverageSpeedModelCopyWith<$Res>? get averageSpeed;

}
/// @nodoc
class __$FastestLapModelCopyWithImpl<$Res>
    implements _$FastestLapModelCopyWith<$Res> {
  __$FastestLapModelCopyWithImpl(this._self, this._then);

  final _FastestLapModel _self;
  final $Res Function(_FastestLapModel) _then;

/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? lap = null,Object? time = null,Object? averageSpeed = freezed,}) {
  return _then(_FastestLapModel(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as String,lap: null == lap ? _self.lap : lap // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeModel,averageSpeed: freezed == averageSpeed ? _self.averageSpeed : averageSpeed // ignore: cast_nullable_to_non_nullable
as AverageSpeedModel?,
  ));
}

/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeModelCopyWith<$Res> get time {
  
  return $TimeModelCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of FastestLapModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AverageSpeedModelCopyWith<$Res>? get averageSpeed {
    if (_self.averageSpeed == null) {
    return null;
  }

  return $AverageSpeedModelCopyWith<$Res>(_self.averageSpeed!, (value) {
    return _then(_self.copyWith(averageSpeed: value));
  });
}
}

// dart format on
