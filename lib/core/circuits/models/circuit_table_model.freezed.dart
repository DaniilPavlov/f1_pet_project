// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circuit_table_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircuitTableModel {

@JsonKey(name: 'Circuits') List<CircuitModel> get circuits;
/// Create a copy of CircuitTableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitTableModelCopyWith<CircuitTableModel> get copyWith => _$CircuitTableModelCopyWithImpl<CircuitTableModel>(this as CircuitTableModel, _$identity);

  /// Serializes this CircuitTableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitTableModel&&const DeepCollectionEquality().equals(other.circuits, circuits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(circuits));

@override
String toString() {
  return 'CircuitTableModel(circuits: $circuits)';
}


}

/// @nodoc
abstract mixin class $CircuitTableModelCopyWith<$Res>  {
  factory $CircuitTableModelCopyWith(CircuitTableModel value, $Res Function(CircuitTableModel) _then) = _$CircuitTableModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'Circuits') List<CircuitModel> circuits
});




}
/// @nodoc
class _$CircuitTableModelCopyWithImpl<$Res>
    implements $CircuitTableModelCopyWith<$Res> {
  _$CircuitTableModelCopyWithImpl(this._self, this._then);

  final CircuitTableModel _self;
  final $Res Function(CircuitTableModel) _then;

/// Create a copy of CircuitTableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? circuits = null,}) {
  return _then(_self.copyWith(
circuits: null == circuits ? _self.circuits : circuits // ignore: cast_nullable_to_non_nullable
as List<CircuitModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CircuitTableModel].
extension CircuitTableModelPatterns on CircuitTableModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircuitTableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircuitTableModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircuitTableModel value)  $default,){
final _that = this;
switch (_that) {
case _CircuitTableModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircuitTableModel value)?  $default,){
final _that = this;
switch (_that) {
case _CircuitTableModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'Circuits')  List<CircuitModel> circuits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircuitTableModel() when $default != null:
return $default(_that.circuits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'Circuits')  List<CircuitModel> circuits)  $default,) {final _that = this;
switch (_that) {
case _CircuitTableModel():
return $default(_that.circuits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'Circuits')  List<CircuitModel> circuits)?  $default,) {final _that = this;
switch (_that) {
case _CircuitTableModel() when $default != null:
return $default(_that.circuits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircuitTableModel implements CircuitTableModel {
  const _CircuitTableModel({@JsonKey(name: 'Circuits') required final  List<CircuitModel> circuits}): _circuits = circuits;
  factory _CircuitTableModel.fromJson(Map<String, dynamic> json) => _$CircuitTableModelFromJson(json);

 final  List<CircuitModel> _circuits;
@override@JsonKey(name: 'Circuits') List<CircuitModel> get circuits {
  if (_circuits is EqualUnmodifiableListView) return _circuits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_circuits);
}


/// Create a copy of CircuitTableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircuitTableModelCopyWith<_CircuitTableModel> get copyWith => __$CircuitTableModelCopyWithImpl<_CircuitTableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircuitTableModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircuitTableModel&&const DeepCollectionEquality().equals(other._circuits, _circuits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_circuits));

@override
String toString() {
  return 'CircuitTableModel(circuits: $circuits)';
}


}

/// @nodoc
abstract mixin class _$CircuitTableModelCopyWith<$Res> implements $CircuitTableModelCopyWith<$Res> {
  factory _$CircuitTableModelCopyWith(_CircuitTableModel value, $Res Function(_CircuitTableModel) _then) = __$CircuitTableModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'Circuits') List<CircuitModel> circuits
});




}
/// @nodoc
class __$CircuitTableModelCopyWithImpl<$Res>
    implements _$CircuitTableModelCopyWith<$Res> {
  __$CircuitTableModelCopyWithImpl(this._self, this._then);

  final _CircuitTableModel _self;
  final $Res Function(_CircuitTableModel) _then;

/// Create a copy of CircuitTableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? circuits = null,}) {
  return _then(_CircuitTableModel(
circuits: null == circuits ? _self._circuits : circuits // ignore: cast_nullable_to_non_nullable
as List<CircuitModel>,
  ));
}


}

// dart format on
