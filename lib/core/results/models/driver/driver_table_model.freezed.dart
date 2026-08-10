// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_table_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverTableModel {

 String get driverId;@JsonKey(name: 'Drivers') List<DriverModel> get drivers;
/// Create a copy of DriverTableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverTableModelCopyWith<DriverTableModel> get copyWith => _$DriverTableModelCopyWithImpl<DriverTableModel>(this as DriverTableModel, _$identity);

  /// Serializes this DriverTableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverTableModel&&(identical(other.driverId, driverId) || other.driverId == driverId)&&const DeepCollectionEquality().equals(other.drivers, drivers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverId,const DeepCollectionEquality().hash(drivers));

@override
String toString() {
  return 'DriverTableModel(driverId: $driverId, drivers: $drivers)';
}


}

/// @nodoc
abstract mixin class $DriverTableModelCopyWith<$Res>  {
  factory $DriverTableModelCopyWith(DriverTableModel value, $Res Function(DriverTableModel) _then) = _$DriverTableModelCopyWithImpl;
@useResult
$Res call({
 String driverId,@JsonKey(name: 'Drivers') List<DriverModel> drivers
});




}
/// @nodoc
class _$DriverTableModelCopyWithImpl<$Res>
    implements $DriverTableModelCopyWith<$Res> {
  _$DriverTableModelCopyWithImpl(this._self, this._then);

  final DriverTableModel _self;
  final $Res Function(DriverTableModel) _then;

/// Create a copy of DriverTableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? driverId = null,Object? drivers = null,}) {
  return _then(_self.copyWith(
driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String,drivers: null == drivers ? _self.drivers : drivers // ignore: cast_nullable_to_non_nullable
as List<DriverModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverTableModel].
extension DriverTableModelPatterns on DriverTableModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverTableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverTableModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverTableModel value)  $default,){
final _that = this;
switch (_that) {
case _DriverTableModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverTableModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriverTableModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String driverId, @JsonKey(name: 'Drivers')  List<DriverModel> drivers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverTableModel() when $default != null:
return $default(_that.driverId,_that.drivers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String driverId, @JsonKey(name: 'Drivers')  List<DriverModel> drivers)  $default,) {final _that = this;
switch (_that) {
case _DriverTableModel():
return $default(_that.driverId,_that.drivers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String driverId, @JsonKey(name: 'Drivers')  List<DriverModel> drivers)?  $default,) {final _that = this;
switch (_that) {
case _DriverTableModel() when $default != null:
return $default(_that.driverId,_that.drivers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverTableModel implements DriverTableModel {
  const _DriverTableModel({required this.driverId, @JsonKey(name: 'Drivers') required final  List<DriverModel> drivers}): _drivers = drivers;
  factory _DriverTableModel.fromJson(Map<String, dynamic> json) => _$DriverTableModelFromJson(json);

@override final  String driverId;
 final  List<DriverModel> _drivers;
@override@JsonKey(name: 'Drivers') List<DriverModel> get drivers {
  if (_drivers is EqualUnmodifiableListView) return _drivers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drivers);
}


/// Create a copy of DriverTableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverTableModelCopyWith<_DriverTableModel> get copyWith => __$DriverTableModelCopyWithImpl<_DriverTableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverTableModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverTableModel&&(identical(other.driverId, driverId) || other.driverId == driverId)&&const DeepCollectionEquality().equals(other._drivers, _drivers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverId,const DeepCollectionEquality().hash(_drivers));

@override
String toString() {
  return 'DriverTableModel(driverId: $driverId, drivers: $drivers)';
}


}

/// @nodoc
abstract mixin class _$DriverTableModelCopyWith<$Res> implements $DriverTableModelCopyWith<$Res> {
  factory _$DriverTableModelCopyWith(_DriverTableModel value, $Res Function(_DriverTableModel) _then) = __$DriverTableModelCopyWithImpl;
@override @useResult
$Res call({
 String driverId,@JsonKey(name: 'Drivers') List<DriverModel> drivers
});




}
/// @nodoc
class __$DriverTableModelCopyWithImpl<$Res>
    implements _$DriverTableModelCopyWith<$Res> {
  __$DriverTableModelCopyWithImpl(this._self, this._then);

  final _DriverTableModel _self;
  final $Res Function(_DriverTableModel) _then;

/// Create a copy of DriverTableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? driverId = null,Object? drivers = null,}) {
  return _then(_DriverTableModel(
driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String,drivers: null == drivers ? _self._drivers : drivers // ignore: cast_nullable_to_non_nullable
as List<DriverModel>,
  ));
}


}

// dart format on
