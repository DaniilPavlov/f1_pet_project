// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circuit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircuitModel {

 String get circuitId; String get url; String get circuitName;@JsonKey(name: 'Location') CircuitLocationModel get location;
/// Create a copy of CircuitModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitModelCopyWith<CircuitModel> get copyWith => _$CircuitModelCopyWithImpl<CircuitModel>(this as CircuitModel, _$identity);

  /// Serializes this CircuitModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitModel&&(identical(other.circuitId, circuitId) || other.circuitId == circuitId)&&(identical(other.url, url) || other.url == url)&&(identical(other.circuitName, circuitName) || other.circuitName == circuitName)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,circuitId,url,circuitName,location);

@override
String toString() {
  return 'CircuitModel(circuitId: $circuitId, url: $url, circuitName: $circuitName, location: $location)';
}


}

/// @nodoc
abstract mixin class $CircuitModelCopyWith<$Res>  {
  factory $CircuitModelCopyWith(CircuitModel value, $Res Function(CircuitModel) _then) = _$CircuitModelCopyWithImpl;
@useResult
$Res call({
 String circuitId, String url, String circuitName,@JsonKey(name: 'Location') CircuitLocationModel location
});


$CircuitLocationModelCopyWith<$Res> get location;

}
/// @nodoc
class _$CircuitModelCopyWithImpl<$Res>
    implements $CircuitModelCopyWith<$Res> {
  _$CircuitModelCopyWithImpl(this._self, this._then);

  final CircuitModel _self;
  final $Res Function(CircuitModel) _then;

/// Create a copy of CircuitModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? circuitId = null,Object? url = null,Object? circuitName = null,Object? location = null,}) {
  return _then(_self.copyWith(
circuitId: null == circuitId ? _self.circuitId : circuitId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,circuitName: null == circuitName ? _self.circuitName : circuitName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CircuitLocationModel,
  ));
}
/// Create a copy of CircuitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CircuitLocationModelCopyWith<$Res> get location {
  
  return $CircuitLocationModelCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [CircuitModel].
extension CircuitModelPatterns on CircuitModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircuitModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircuitModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircuitModel value)  $default,){
final _that = this;
switch (_that) {
case _CircuitModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircuitModel value)?  $default,){
final _that = this;
switch (_that) {
case _CircuitModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String circuitId,  String url,  String circuitName, @JsonKey(name: 'Location')  CircuitLocationModel location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircuitModel() when $default != null:
return $default(_that.circuitId,_that.url,_that.circuitName,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String circuitId,  String url,  String circuitName, @JsonKey(name: 'Location')  CircuitLocationModel location)  $default,) {final _that = this;
switch (_that) {
case _CircuitModel():
return $default(_that.circuitId,_that.url,_that.circuitName,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String circuitId,  String url,  String circuitName, @JsonKey(name: 'Location')  CircuitLocationModel location)?  $default,) {final _that = this;
switch (_that) {
case _CircuitModel() when $default != null:
return $default(_that.circuitId,_that.url,_that.circuitName,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircuitModel implements CircuitModel {
  const _CircuitModel({required this.circuitId, required this.url, required this.circuitName, @JsonKey(name: 'Location') required this.location});
  factory _CircuitModel.fromJson(Map<String, dynamic> json) => _$CircuitModelFromJson(json);

@override final  String circuitId;
@override final  String url;
@override final  String circuitName;
@override@JsonKey(name: 'Location') final  CircuitLocationModel location;

/// Create a copy of CircuitModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircuitModelCopyWith<_CircuitModel> get copyWith => __$CircuitModelCopyWithImpl<_CircuitModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircuitModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircuitModel&&(identical(other.circuitId, circuitId) || other.circuitId == circuitId)&&(identical(other.url, url) || other.url == url)&&(identical(other.circuitName, circuitName) || other.circuitName == circuitName)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,circuitId,url,circuitName,location);

@override
String toString() {
  return 'CircuitModel(circuitId: $circuitId, url: $url, circuitName: $circuitName, location: $location)';
}


}

/// @nodoc
abstract mixin class _$CircuitModelCopyWith<$Res> implements $CircuitModelCopyWith<$Res> {
  factory _$CircuitModelCopyWith(_CircuitModel value, $Res Function(_CircuitModel) _then) = __$CircuitModelCopyWithImpl;
@override @useResult
$Res call({
 String circuitId, String url, String circuitName,@JsonKey(name: 'Location') CircuitLocationModel location
});


@override $CircuitLocationModelCopyWith<$Res> get location;

}
/// @nodoc
class __$CircuitModelCopyWithImpl<$Res>
    implements _$CircuitModelCopyWith<$Res> {
  __$CircuitModelCopyWithImpl(this._self, this._then);

  final _CircuitModel _self;
  final $Res Function(_CircuitModel) _then;

/// Create a copy of CircuitModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? circuitId = null,Object? url = null,Object? circuitName = null,Object? location = null,}) {
  return _then(_CircuitModel(
circuitId: null == circuitId ? _self.circuitId : circuitId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,circuitName: null == circuitName ? _self.circuitName : circuitName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CircuitLocationModel,
  ));
}

/// Create a copy of CircuitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CircuitLocationModelCopyWith<$Res> get location {
  
  return $CircuitLocationModelCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
