// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'standings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StandingsModel {

@JsonKey(name: 'StandingsTable') StandingsTableModel get standingsTable;
/// Create a copy of StandingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StandingsModelCopyWith<StandingsModel> get copyWith => _$StandingsModelCopyWithImpl<StandingsModel>(this as StandingsModel, _$identity);

  /// Serializes this StandingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StandingsModel&&(identical(other.standingsTable, standingsTable) || other.standingsTable == standingsTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,standingsTable);

@override
String toString() {
  return 'StandingsModel(standingsTable: $standingsTable)';
}


}

/// @nodoc
abstract mixin class $StandingsModelCopyWith<$Res>  {
  factory $StandingsModelCopyWith(StandingsModel value, $Res Function(StandingsModel) _then) = _$StandingsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'StandingsTable') StandingsTableModel standingsTable
});


$StandingsTableModelCopyWith<$Res> get standingsTable;

}
/// @nodoc
class _$StandingsModelCopyWithImpl<$Res>
    implements $StandingsModelCopyWith<$Res> {
  _$StandingsModelCopyWithImpl(this._self, this._then);

  final StandingsModel _self;
  final $Res Function(StandingsModel) _then;

/// Create a copy of StandingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? standingsTable = null,}) {
  return _then(_self.copyWith(
standingsTable: null == standingsTable ? _self.standingsTable : standingsTable // ignore: cast_nullable_to_non_nullable
as StandingsTableModel,
  ));
}
/// Create a copy of StandingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StandingsTableModelCopyWith<$Res> get standingsTable {
  
  return $StandingsTableModelCopyWith<$Res>(_self.standingsTable, (value) {
    return _then(_self.copyWith(standingsTable: value));
  });
}
}


/// Adds pattern-matching-related methods to [StandingsModel].
extension StandingsModelPatterns on StandingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StandingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StandingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StandingsModel value)  $default,){
final _that = this;
switch (_that) {
case _StandingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StandingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _StandingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'StandingsTable')  StandingsTableModel standingsTable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StandingsModel() when $default != null:
return $default(_that.standingsTable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'StandingsTable')  StandingsTableModel standingsTable)  $default,) {final _that = this;
switch (_that) {
case _StandingsModel():
return $default(_that.standingsTable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'StandingsTable')  StandingsTableModel standingsTable)?  $default,) {final _that = this;
switch (_that) {
case _StandingsModel() when $default != null:
return $default(_that.standingsTable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StandingsModel implements StandingsModel {
  const _StandingsModel({@JsonKey(name: 'StandingsTable') required this.standingsTable});
  factory _StandingsModel.fromJson(Map<String, dynamic> json) => _$StandingsModelFromJson(json);

@override@JsonKey(name: 'StandingsTable') final  StandingsTableModel standingsTable;

/// Create a copy of StandingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StandingsModelCopyWith<_StandingsModel> get copyWith => __$StandingsModelCopyWithImpl<_StandingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StandingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StandingsModel&&(identical(other.standingsTable, standingsTable) || other.standingsTable == standingsTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,standingsTable);

@override
String toString() {
  return 'StandingsModel(standingsTable: $standingsTable)';
}


}

/// @nodoc
abstract mixin class _$StandingsModelCopyWith<$Res> implements $StandingsModelCopyWith<$Res> {
  factory _$StandingsModelCopyWith(_StandingsModel value, $Res Function(_StandingsModel) _then) = __$StandingsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'StandingsTable') StandingsTableModel standingsTable
});


@override $StandingsTableModelCopyWith<$Res> get standingsTable;

}
/// @nodoc
class __$StandingsModelCopyWithImpl<$Res>
    implements _$StandingsModelCopyWith<$Res> {
  __$StandingsModelCopyWithImpl(this._self, this._then);

  final _StandingsModel _self;
  final $Res Function(_StandingsModel) _then;

/// Create a copy of StandingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? standingsTable = null,}) {
  return _then(_StandingsModel(
standingsTable: null == standingsTable ? _self.standingsTable : standingsTable // ignore: cast_nullable_to_non_nullable
as StandingsTableModel,
  ));
}

/// Create a copy of StandingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StandingsTableModelCopyWith<$Res> get standingsTable {
  
  return $StandingsTableModelCopyWith<$Res>(_self.standingsTable, (value) {
    return _then(_self.copyWith(standingsTable: value));
  });
}
}

// dart format on
