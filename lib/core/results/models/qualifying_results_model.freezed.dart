// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qualifying_results_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QualifyingResultsModel {

 String get number; String get position;@JsonKey(name: 'Driver') DriverModel get driver;@JsonKey(name: 'Constructor') ConstructorModel get constructor;@JsonKey(name: 'Q1') String get q1;@JsonKey(name: 'Q2') String? get q2;@JsonKey(name: 'Q3') String? get q3;
/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QualifyingResultsModelCopyWith<QualifyingResultsModel> get copyWith => _$QualifyingResultsModelCopyWithImpl<QualifyingResultsModel>(this as QualifyingResultsModel, _$identity);

  /// Serializes this QualifyingResultsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QualifyingResultsModel&&(identical(other.number, number) || other.number == number)&&(identical(other.position, position) || other.position == position)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.constructor, constructor) || other.constructor == constructor)&&(identical(other.q1, q1) || other.q1 == q1)&&(identical(other.q2, q2) || other.q2 == q2)&&(identical(other.q3, q3) || other.q3 == q3));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,position,driver,constructor,q1,q2,q3);

@override
String toString() {
  return 'QualifyingResultsModel(number: $number, position: $position, driver: $driver, constructor: $constructor, q1: $q1, q2: $q2, q3: $q3)';
}


}

/// @nodoc
abstract mixin class $QualifyingResultsModelCopyWith<$Res>  {
  factory $QualifyingResultsModelCopyWith(QualifyingResultsModel value, $Res Function(QualifyingResultsModel) _then) = _$QualifyingResultsModelCopyWithImpl;
@useResult
$Res call({
 String number, String position,@JsonKey(name: 'Driver') DriverModel driver,@JsonKey(name: 'Constructor') ConstructorModel constructor,@JsonKey(name: 'Q1') String q1,@JsonKey(name: 'Q2') String? q2,@JsonKey(name: 'Q3') String? q3
});


$DriverModelCopyWith<$Res> get driver;$ConstructorModelCopyWith<$Res> get constructor;

}
/// @nodoc
class _$QualifyingResultsModelCopyWithImpl<$Res>
    implements $QualifyingResultsModelCopyWith<$Res> {
  _$QualifyingResultsModelCopyWithImpl(this._self, this._then);

  final QualifyingResultsModel _self;
  final $Res Function(QualifyingResultsModel) _then;

/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? position = null,Object? driver = null,Object? constructor = null,Object? q1 = null,Object? q2 = freezed,Object? q3 = freezed,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverModel,constructor: null == constructor ? _self.constructor : constructor // ignore: cast_nullable_to_non_nullable
as ConstructorModel,q1: null == q1 ? _self.q1 : q1 // ignore: cast_nullable_to_non_nullable
as String,q2: freezed == q2 ? _self.q2 : q2 // ignore: cast_nullable_to_non_nullable
as String?,q3: freezed == q3 ? _self.q3 : q3 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverModelCopyWith<$Res> get driver {
  
  return $DriverModelCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstructorModelCopyWith<$Res> get constructor {
  
  return $ConstructorModelCopyWith<$Res>(_self.constructor, (value) {
    return _then(_self.copyWith(constructor: value));
  });
}
}


/// Adds pattern-matching-related methods to [QualifyingResultsModel].
extension QualifyingResultsModelPatterns on QualifyingResultsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QualifyingResultsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QualifyingResultsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QualifyingResultsModel value)  $default,){
final _that = this;
switch (_that) {
case _QualifyingResultsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QualifyingResultsModel value)?  $default,){
final _that = this;
switch (_that) {
case _QualifyingResultsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String number,  String position, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructor')  ConstructorModel constructor, @JsonKey(name: 'Q1')  String q1, @JsonKey(name: 'Q2')  String? q2, @JsonKey(name: 'Q3')  String? q3)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QualifyingResultsModel() when $default != null:
return $default(_that.number,_that.position,_that.driver,_that.constructor,_that.q1,_that.q2,_that.q3);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String number,  String position, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructor')  ConstructorModel constructor, @JsonKey(name: 'Q1')  String q1, @JsonKey(name: 'Q2')  String? q2, @JsonKey(name: 'Q3')  String? q3)  $default,) {final _that = this;
switch (_that) {
case _QualifyingResultsModel():
return $default(_that.number,_that.position,_that.driver,_that.constructor,_that.q1,_that.q2,_that.q3);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String number,  String position, @JsonKey(name: 'Driver')  DriverModel driver, @JsonKey(name: 'Constructor')  ConstructorModel constructor, @JsonKey(name: 'Q1')  String q1, @JsonKey(name: 'Q2')  String? q2, @JsonKey(name: 'Q3')  String? q3)?  $default,) {final _that = this;
switch (_that) {
case _QualifyingResultsModel() when $default != null:
return $default(_that.number,_that.position,_that.driver,_that.constructor,_that.q1,_that.q2,_that.q3);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QualifyingResultsModel implements QualifyingResultsModel {
  const _QualifyingResultsModel({required this.number, required this.position, @JsonKey(name: 'Driver') required this.driver, @JsonKey(name: 'Constructor') required this.constructor, @JsonKey(name: 'Q1') required this.q1, @JsonKey(name: 'Q2') this.q2, @JsonKey(name: 'Q3') this.q3});
  factory _QualifyingResultsModel.fromJson(Map<String, dynamic> json) => _$QualifyingResultsModelFromJson(json);

@override final  String number;
@override final  String position;
@override@JsonKey(name: 'Driver') final  DriverModel driver;
@override@JsonKey(name: 'Constructor') final  ConstructorModel constructor;
@override@JsonKey(name: 'Q1') final  String q1;
@override@JsonKey(name: 'Q2') final  String? q2;
@override@JsonKey(name: 'Q3') final  String? q3;

/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QualifyingResultsModelCopyWith<_QualifyingResultsModel> get copyWith => __$QualifyingResultsModelCopyWithImpl<_QualifyingResultsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QualifyingResultsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QualifyingResultsModel&&(identical(other.number, number) || other.number == number)&&(identical(other.position, position) || other.position == position)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.constructor, constructor) || other.constructor == constructor)&&(identical(other.q1, q1) || other.q1 == q1)&&(identical(other.q2, q2) || other.q2 == q2)&&(identical(other.q3, q3) || other.q3 == q3));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,position,driver,constructor,q1,q2,q3);

@override
String toString() {
  return 'QualifyingResultsModel(number: $number, position: $position, driver: $driver, constructor: $constructor, q1: $q1, q2: $q2, q3: $q3)';
}


}

/// @nodoc
abstract mixin class _$QualifyingResultsModelCopyWith<$Res> implements $QualifyingResultsModelCopyWith<$Res> {
  factory _$QualifyingResultsModelCopyWith(_QualifyingResultsModel value, $Res Function(_QualifyingResultsModel) _then) = __$QualifyingResultsModelCopyWithImpl;
@override @useResult
$Res call({
 String number, String position,@JsonKey(name: 'Driver') DriverModel driver,@JsonKey(name: 'Constructor') ConstructorModel constructor,@JsonKey(name: 'Q1') String q1,@JsonKey(name: 'Q2') String? q2,@JsonKey(name: 'Q3') String? q3
});


@override $DriverModelCopyWith<$Res> get driver;@override $ConstructorModelCopyWith<$Res> get constructor;

}
/// @nodoc
class __$QualifyingResultsModelCopyWithImpl<$Res>
    implements _$QualifyingResultsModelCopyWith<$Res> {
  __$QualifyingResultsModelCopyWithImpl(this._self, this._then);

  final _QualifyingResultsModel _self;
  final $Res Function(_QualifyingResultsModel) _then;

/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? position = null,Object? driver = null,Object? constructor = null,Object? q1 = null,Object? q2 = freezed,Object? q3 = freezed,}) {
  return _then(_QualifyingResultsModel(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverModel,constructor: null == constructor ? _self.constructor : constructor // ignore: cast_nullable_to_non_nullable
as ConstructorModel,q1: null == q1 ? _self.q1 : q1 // ignore: cast_nullable_to_non_nullable
as String,q2: freezed == q2 ? _self.q2 : q2 // ignore: cast_nullable_to_non_nullable
as String?,q3: freezed == q3 ? _self.q3 : q3 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QualifyingResultsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverModelCopyWith<$Res> get driver {
  
  return $DriverModelCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of QualifyingResultsModel
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
