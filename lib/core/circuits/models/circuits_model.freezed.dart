// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circuits_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircuitsModel {

@JsonKey(name: 'CircuitTable') CircuitTableModel get circuitTable;
/// Create a copy of CircuitsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitsModelCopyWith<CircuitsModel> get copyWith => _$CircuitsModelCopyWithImpl<CircuitsModel>(this as CircuitsModel, _$identity);

  /// Serializes this CircuitsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitsModel&&(identical(other.circuitTable, circuitTable) || other.circuitTable == circuitTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,circuitTable);

@override
String toString() {
  return 'CircuitsModel(circuitTable: $circuitTable)';
}


}

/// @nodoc
abstract mixin class $CircuitsModelCopyWith<$Res>  {
  factory $CircuitsModelCopyWith(CircuitsModel value, $Res Function(CircuitsModel) _then) = _$CircuitsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'CircuitTable') CircuitTableModel circuitTable
});


$CircuitTableModelCopyWith<$Res> get circuitTable;

}
/// @nodoc
class _$CircuitsModelCopyWithImpl<$Res>
    implements $CircuitsModelCopyWith<$Res> {
  _$CircuitsModelCopyWithImpl(this._self, this._then);

  final CircuitsModel _self;
  final $Res Function(CircuitsModel) _then;

/// Create a copy of CircuitsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? circuitTable = null,}) {
  return _then(_self.copyWith(
circuitTable: null == circuitTable ? _self.circuitTable : circuitTable // ignore: cast_nullable_to_non_nullable
as CircuitTableModel,
  ));
}
/// Create a copy of CircuitsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CircuitTableModelCopyWith<$Res> get circuitTable {
  
  return $CircuitTableModelCopyWith<$Res>(_self.circuitTable, (value) {
    return _then(_self.copyWith(circuitTable: value));
  });
}
}


/// Adds pattern-matching-related methods to [CircuitsModel].
extension CircuitsModelPatterns on CircuitsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircuitsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircuitsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircuitsModel value)  $default,){
final _that = this;
switch (_that) {
case _CircuitsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircuitsModel value)?  $default,){
final _that = this;
switch (_that) {
case _CircuitsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'CircuitTable')  CircuitTableModel circuitTable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircuitsModel() when $default != null:
return $default(_that.circuitTable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'CircuitTable')  CircuitTableModel circuitTable)  $default,) {final _that = this;
switch (_that) {
case _CircuitsModel():
return $default(_that.circuitTable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'CircuitTable')  CircuitTableModel circuitTable)?  $default,) {final _that = this;
switch (_that) {
case _CircuitsModel() when $default != null:
return $default(_that.circuitTable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircuitsModel implements CircuitsModel {
  const _CircuitsModel({@JsonKey(name: 'CircuitTable') required this.circuitTable});
  factory _CircuitsModel.fromJson(Map<String, dynamic> json) => _$CircuitsModelFromJson(json);

@override@JsonKey(name: 'CircuitTable') final  CircuitTableModel circuitTable;

/// Create a copy of CircuitsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircuitsModelCopyWith<_CircuitsModel> get copyWith => __$CircuitsModelCopyWithImpl<_CircuitsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircuitsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircuitsModel&&(identical(other.circuitTable, circuitTable) || other.circuitTable == circuitTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,circuitTable);

@override
String toString() {
  return 'CircuitsModel(circuitTable: $circuitTable)';
}


}

/// @nodoc
abstract mixin class _$CircuitsModelCopyWith<$Res> implements $CircuitsModelCopyWith<$Res> {
  factory _$CircuitsModelCopyWith(_CircuitsModel value, $Res Function(_CircuitsModel) _then) = __$CircuitsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'CircuitTable') CircuitTableModel circuitTable
});


@override $CircuitTableModelCopyWith<$Res> get circuitTable;

}
/// @nodoc
class __$CircuitsModelCopyWithImpl<$Res>
    implements _$CircuitsModelCopyWith<$Res> {
  __$CircuitsModelCopyWithImpl(this._self, this._then);

  final _CircuitsModel _self;
  final $Res Function(_CircuitsModel) _then;

/// Create a copy of CircuitsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? circuitTable = null,}) {
  return _then(_CircuitsModel(
circuitTable: null == circuitTable ? _self.circuitTable : circuitTable // ignore: cast_nullable_to_non_nullable
as CircuitTableModel,
  ));
}

/// Create a copy of CircuitsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CircuitTableModelCopyWith<$Res> get circuitTable {
  
  return $CircuitTableModelCopyWith<$Res>(_self.circuitTable, (value) {
    return _then(_self.copyWith(circuitTable: value));
  });
}
}

// dart format on
