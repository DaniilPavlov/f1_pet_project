// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pit_stops_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PitStopsModel {

 String get driverId; String get lap; String get stop; String get time; String get duration;
/// Create a copy of PitStopsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PitStopsModelCopyWith<PitStopsModel> get copyWith => _$PitStopsModelCopyWithImpl<PitStopsModel>(this as PitStopsModel, _$identity);

  /// Serializes this PitStopsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PitStopsModel&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.lap, lap) || other.lap == lap)&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.time, time) || other.time == time)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverId,lap,stop,time,duration);

@override
String toString() {
  return 'PitStopsModel(driverId: $driverId, lap: $lap, stop: $stop, time: $time, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $PitStopsModelCopyWith<$Res>  {
  factory $PitStopsModelCopyWith(PitStopsModel value, $Res Function(PitStopsModel) _then) = _$PitStopsModelCopyWithImpl;
@useResult
$Res call({
 String driverId, String lap, String stop, String time, String duration
});




}
/// @nodoc
class _$PitStopsModelCopyWithImpl<$Res>
    implements $PitStopsModelCopyWith<$Res> {
  _$PitStopsModelCopyWithImpl(this._self, this._then);

  final PitStopsModel _self;
  final $Res Function(PitStopsModel) _then;

/// Create a copy of PitStopsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? driverId = null,Object? lap = null,Object? stop = null,Object? time = null,Object? duration = null,}) {
  return _then(_self.copyWith(
driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String,lap: null == lap ? _self.lap : lap // ignore: cast_nullable_to_non_nullable
as String,stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PitStopsModel].
extension PitStopsModelPatterns on PitStopsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PitStopsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PitStopsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PitStopsModel value)  $default,){
final _that = this;
switch (_that) {
case _PitStopsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PitStopsModel value)?  $default,){
final _that = this;
switch (_that) {
case _PitStopsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String driverId,  String lap,  String stop,  String time,  String duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PitStopsModel() when $default != null:
return $default(_that.driverId,_that.lap,_that.stop,_that.time,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String driverId,  String lap,  String stop,  String time,  String duration)  $default,) {final _that = this;
switch (_that) {
case _PitStopsModel():
return $default(_that.driverId,_that.lap,_that.stop,_that.time,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String driverId,  String lap,  String stop,  String time,  String duration)?  $default,) {final _that = this;
switch (_that) {
case _PitStopsModel() when $default != null:
return $default(_that.driverId,_that.lap,_that.stop,_that.time,_that.duration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PitStopsModel implements PitStopsModel {
  const _PitStopsModel({required this.driverId, required this.lap, required this.stop, required this.time, required this.duration});
  factory _PitStopsModel.fromJson(Map<String, dynamic> json) => _$PitStopsModelFromJson(json);

@override final  String driverId;
@override final  String lap;
@override final  String stop;
@override final  String time;
@override final  String duration;

/// Create a copy of PitStopsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PitStopsModelCopyWith<_PitStopsModel> get copyWith => __$PitStopsModelCopyWithImpl<_PitStopsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PitStopsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PitStopsModel&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.lap, lap) || other.lap == lap)&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.time, time) || other.time == time)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverId,lap,stop,time,duration);

@override
String toString() {
  return 'PitStopsModel(driverId: $driverId, lap: $lap, stop: $stop, time: $time, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$PitStopsModelCopyWith<$Res> implements $PitStopsModelCopyWith<$Res> {
  factory _$PitStopsModelCopyWith(_PitStopsModel value, $Res Function(_PitStopsModel) _then) = __$PitStopsModelCopyWithImpl;
@override @useResult
$Res call({
 String driverId, String lap, String stop, String time, String duration
});




}
/// @nodoc
class __$PitStopsModelCopyWithImpl<$Res>
    implements _$PitStopsModelCopyWith<$Res> {
  __$PitStopsModelCopyWithImpl(this._self, this._then);

  final _PitStopsModel _self;
  final $Res Function(_PitStopsModel) _then;

/// Create a copy of PitStopsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? driverId = null,Object? lap = null,Object? stop = null,Object? time = null,Object? duration = null,}) {
  return _then(_PitStopsModel(
driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String,lap: null == lap ? _self.lap : lap // ignore: cast_nullable_to_non_nullable
as String,stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
