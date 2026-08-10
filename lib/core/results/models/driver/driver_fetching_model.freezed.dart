// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_fetching_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverFetchingModel {

@JsonKey(name: 'DriverTable') DriverTableModel get driverTable;
/// Create a copy of DriverFetchingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverFetchingModelCopyWith<DriverFetchingModel> get copyWith => _$DriverFetchingModelCopyWithImpl<DriverFetchingModel>(this as DriverFetchingModel, _$identity);

  /// Serializes this DriverFetchingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverFetchingModel&&(identical(other.driverTable, driverTable) || other.driverTable == driverTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverTable);

@override
String toString() {
  return 'DriverFetchingModel(driverTable: $driverTable)';
}


}

/// @nodoc
abstract mixin class $DriverFetchingModelCopyWith<$Res>  {
  factory $DriverFetchingModelCopyWith(DriverFetchingModel value, $Res Function(DriverFetchingModel) _then) = _$DriverFetchingModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'DriverTable') DriverTableModel driverTable
});


$DriverTableModelCopyWith<$Res> get driverTable;

}
/// @nodoc
class _$DriverFetchingModelCopyWithImpl<$Res>
    implements $DriverFetchingModelCopyWith<$Res> {
  _$DriverFetchingModelCopyWithImpl(this._self, this._then);

  final DriverFetchingModel _self;
  final $Res Function(DriverFetchingModel) _then;

/// Create a copy of DriverFetchingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? driverTable = null,}) {
  return _then(_self.copyWith(
driverTable: null == driverTable ? _self.driverTable : driverTable // ignore: cast_nullable_to_non_nullable
as DriverTableModel,
  ));
}
/// Create a copy of DriverFetchingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverTableModelCopyWith<$Res> get driverTable {
  
  return $DriverTableModelCopyWith<$Res>(_self.driverTable, (value) {
    return _then(_self.copyWith(driverTable: value));
  });
}
}


/// Adds pattern-matching-related methods to [DriverFetchingModel].
extension DriverFetchingModelPatterns on DriverFetchingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverFetchingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverFetchingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverFetchingModel value)  $default,){
final _that = this;
switch (_that) {
case _DriverFetchingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverFetchingModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriverFetchingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'DriverTable')  DriverTableModel driverTable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverFetchingModel() when $default != null:
return $default(_that.driverTable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'DriverTable')  DriverTableModel driverTable)  $default,) {final _that = this;
switch (_that) {
case _DriverFetchingModel():
return $default(_that.driverTable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'DriverTable')  DriverTableModel driverTable)?  $default,) {final _that = this;
switch (_that) {
case _DriverFetchingModel() when $default != null:
return $default(_that.driverTable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverFetchingModel implements DriverFetchingModel {
  const _DriverFetchingModel({@JsonKey(name: 'DriverTable') required this.driverTable});
  factory _DriverFetchingModel.fromJson(Map<String, dynamic> json) => _$DriverFetchingModelFromJson(json);

@override@JsonKey(name: 'DriverTable') final  DriverTableModel driverTable;

/// Create a copy of DriverFetchingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverFetchingModelCopyWith<_DriverFetchingModel> get copyWith => __$DriverFetchingModelCopyWithImpl<_DriverFetchingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverFetchingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverFetchingModel&&(identical(other.driverTable, driverTable) || other.driverTable == driverTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,driverTable);

@override
String toString() {
  return 'DriverFetchingModel(driverTable: $driverTable)';
}


}

/// @nodoc
abstract mixin class _$DriverFetchingModelCopyWith<$Res> implements $DriverFetchingModelCopyWith<$Res> {
  factory _$DriverFetchingModelCopyWith(_DriverFetchingModel value, $Res Function(_DriverFetchingModel) _then) = __$DriverFetchingModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'DriverTable') DriverTableModel driverTable
});


@override $DriverTableModelCopyWith<$Res> get driverTable;

}
/// @nodoc
class __$DriverFetchingModelCopyWithImpl<$Res>
    implements _$DriverFetchingModelCopyWith<$Res> {
  __$DriverFetchingModelCopyWithImpl(this._self, this._then);

  final _DriverFetchingModel _self;
  final $Res Function(_DriverFetchingModel) _then;

/// Create a copy of DriverFetchingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? driverTable = null,}) {
  return _then(_DriverFetchingModel(
driverTable: null == driverTable ? _self.driverTable : driverTable // ignore: cast_nullable_to_non_nullable
as DriverTableModel,
  ));
}

/// Create a copy of DriverFetchingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverTableModelCopyWith<$Res> get driverTable {
  
  return $DriverTableModelCopyWith<$Res>(_self.driverTable, (value) {
    return _then(_self.copyWith(driverTable: value));
  });
}
}

// dart format on
