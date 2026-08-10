// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seasons_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeasonsModel {

@JsonKey(name: 'SeasonTable') SeasonTableModel get seasonTable;
/// Create a copy of SeasonsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonsModelCopyWith<SeasonsModel> get copyWith => _$SeasonsModelCopyWithImpl<SeasonsModel>(this as SeasonsModel, _$identity);

  /// Serializes this SeasonsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonsModel&&(identical(other.seasonTable, seasonTable) || other.seasonTable == seasonTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonTable);

@override
String toString() {
  return 'SeasonsModel(seasonTable: $seasonTable)';
}


}

/// @nodoc
abstract mixin class $SeasonsModelCopyWith<$Res>  {
  factory $SeasonsModelCopyWith(SeasonsModel value, $Res Function(SeasonsModel) _then) = _$SeasonsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'SeasonTable') SeasonTableModel seasonTable
});


$SeasonTableModelCopyWith<$Res> get seasonTable;

}
/// @nodoc
class _$SeasonsModelCopyWithImpl<$Res>
    implements $SeasonsModelCopyWith<$Res> {
  _$SeasonsModelCopyWithImpl(this._self, this._then);

  final SeasonsModel _self;
  final $Res Function(SeasonsModel) _then;

/// Create a copy of SeasonsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonTable = null,}) {
  return _then(_self.copyWith(
seasonTable: null == seasonTable ? _self.seasonTable : seasonTable // ignore: cast_nullable_to_non_nullable
as SeasonTableModel,
  ));
}
/// Create a copy of SeasonsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonTableModelCopyWith<$Res> get seasonTable {
  
  return $SeasonTableModelCopyWith<$Res>(_self.seasonTable, (value) {
    return _then(_self.copyWith(seasonTable: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeasonsModel].
extension SeasonsModelPatterns on SeasonsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonsModel value)  $default,){
final _that = this;
switch (_that) {
case _SeasonsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonsModel value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'SeasonTable')  SeasonTableModel seasonTable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonsModel() when $default != null:
return $default(_that.seasonTable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'SeasonTable')  SeasonTableModel seasonTable)  $default,) {final _that = this;
switch (_that) {
case _SeasonsModel():
return $default(_that.seasonTable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'SeasonTable')  SeasonTableModel seasonTable)?  $default,) {final _that = this;
switch (_that) {
case _SeasonsModel() when $default != null:
return $default(_that.seasonTable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeasonsModel implements SeasonsModel {
  const _SeasonsModel({@JsonKey(name: 'SeasonTable') required this.seasonTable});
  factory _SeasonsModel.fromJson(Map<String, dynamic> json) => _$SeasonsModelFromJson(json);

@override@JsonKey(name: 'SeasonTable') final  SeasonTableModel seasonTable;

/// Create a copy of SeasonsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonsModelCopyWith<_SeasonsModel> get copyWith => __$SeasonsModelCopyWithImpl<_SeasonsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonsModel&&(identical(other.seasonTable, seasonTable) || other.seasonTable == seasonTable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonTable);

@override
String toString() {
  return 'SeasonsModel(seasonTable: $seasonTable)';
}


}

/// @nodoc
abstract mixin class _$SeasonsModelCopyWith<$Res> implements $SeasonsModelCopyWith<$Res> {
  factory _$SeasonsModelCopyWith(_SeasonsModel value, $Res Function(_SeasonsModel) _then) = __$SeasonsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'SeasonTable') SeasonTableModel seasonTable
});


@override $SeasonTableModelCopyWith<$Res> get seasonTable;

}
/// @nodoc
class __$SeasonsModelCopyWithImpl<$Res>
    implements _$SeasonsModelCopyWith<$Res> {
  __$SeasonsModelCopyWithImpl(this._self, this._then);

  final _SeasonsModel _self;
  final $Res Function(_SeasonsModel) _then;

/// Create a copy of SeasonsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonTable = null,}) {
  return _then(_SeasonsModel(
seasonTable: null == seasonTable ? _self.seasonTable : seasonTable // ignore: cast_nullable_to_non_nullable
as SeasonTableModel,
  ));
}

/// Create a copy of SeasonsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonTableModelCopyWith<$Res> get seasonTable {
  
  return $SeasonTableModelCopyWith<$Res>(_self.seasonTable, (value) {
    return _then(_self.copyWith(seasonTable: value));
  });
}
}

// dart format on
