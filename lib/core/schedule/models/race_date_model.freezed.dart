// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'race_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RaceDateModel {

 String get date; String get time;
/// Create a copy of RaceDateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<RaceDateModel> get copyWith => _$RaceDateModelCopyWithImpl<RaceDateModel>(this as RaceDateModel, _$identity);

  /// Serializes this RaceDateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RaceDateModel&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,time);

@override
String toString() {
  return 'RaceDateModel(date: $date, time: $time)';
}


}

/// @nodoc
abstract mixin class $RaceDateModelCopyWith<$Res>  {
  factory $RaceDateModelCopyWith(RaceDateModel value, $Res Function(RaceDateModel) _then) = _$RaceDateModelCopyWithImpl;
@useResult
$Res call({
 String date, String time
});




}
/// @nodoc
class _$RaceDateModelCopyWithImpl<$Res>
    implements $RaceDateModelCopyWith<$Res> {
  _$RaceDateModelCopyWithImpl(this._self, this._then);

  final RaceDateModel _self;
  final $Res Function(RaceDateModel) _then;

/// Create a copy of RaceDateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? time = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RaceDateModel].
extension RaceDateModelPatterns on RaceDateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RaceDateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RaceDateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RaceDateModel value)  $default,){
final _that = this;
switch (_that) {
case _RaceDateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RaceDateModel value)?  $default,){
final _that = this;
switch (_that) {
case _RaceDateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RaceDateModel() when $default != null:
return $default(_that.date,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String time)  $default,) {final _that = this;
switch (_that) {
case _RaceDateModel():
return $default(_that.date,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String time)?  $default,) {final _that = this;
switch (_that) {
case _RaceDateModel() when $default != null:
return $default(_that.date,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RaceDateModel implements RaceDateModel {
  const _RaceDateModel({required this.date, required this.time});
  factory _RaceDateModel.fromJson(Map<String, dynamic> json) => _$RaceDateModelFromJson(json);

@override final  String date;
@override final  String time;

/// Create a copy of RaceDateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RaceDateModelCopyWith<_RaceDateModel> get copyWith => __$RaceDateModelCopyWithImpl<_RaceDateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RaceDateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RaceDateModel&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,time);

@override
String toString() {
  return 'RaceDateModel(date: $date, time: $time)';
}


}

/// @nodoc
abstract mixin class _$RaceDateModelCopyWith<$Res> implements $RaceDateModelCopyWith<$Res> {
  factory _$RaceDateModelCopyWith(_RaceDateModel value, $Res Function(_RaceDateModel) _then) = __$RaceDateModelCopyWithImpl;
@override @useResult
$Res call({
 String date, String time
});




}
/// @nodoc
class __$RaceDateModelCopyWithImpl<$Res>
    implements _$RaceDateModelCopyWith<$Res> {
  __$RaceDateModelCopyWithImpl(this._self, this._then);

  final _RaceDateModel _self;
  final $Res Function(_RaceDateModel) _then;

/// Create a copy of RaceDateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? time = null,}) {
  return _then(_RaceDateModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
