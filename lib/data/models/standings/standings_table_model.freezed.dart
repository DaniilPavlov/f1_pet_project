// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'standings_table_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StandingsTableModel {

@JsonKey(name: 'StandingsLists') List<StandingsListsModel> get standingsLists;
/// Create a copy of StandingsTableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StandingsTableModelCopyWith<StandingsTableModel> get copyWith => _$StandingsTableModelCopyWithImpl<StandingsTableModel>(this as StandingsTableModel, _$identity);

  /// Serializes this StandingsTableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StandingsTableModel&&const DeepCollectionEquality().equals(other.standingsLists, standingsLists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(standingsLists));

@override
String toString() {
  return 'StandingsTableModel(standingsLists: $standingsLists)';
}


}

/// @nodoc
abstract mixin class $StandingsTableModelCopyWith<$Res>  {
  factory $StandingsTableModelCopyWith(StandingsTableModel value, $Res Function(StandingsTableModel) _then) = _$StandingsTableModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'StandingsLists') List<StandingsListsModel> standingsLists
});




}
/// @nodoc
class _$StandingsTableModelCopyWithImpl<$Res>
    implements $StandingsTableModelCopyWith<$Res> {
  _$StandingsTableModelCopyWithImpl(this._self, this._then);

  final StandingsTableModel _self;
  final $Res Function(StandingsTableModel) _then;

/// Create a copy of StandingsTableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? standingsLists = null,}) {
  return _then(_self.copyWith(
standingsLists: null == standingsLists ? _self.standingsLists : standingsLists // ignore: cast_nullable_to_non_nullable
as List<StandingsListsModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [StandingsTableModel].
extension StandingsTableModelPatterns on StandingsTableModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StandingsTableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StandingsTableModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StandingsTableModel value)  $default,){
final _that = this;
switch (_that) {
case _StandingsTableModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StandingsTableModel value)?  $default,){
final _that = this;
switch (_that) {
case _StandingsTableModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'StandingsLists')  List<StandingsListsModel> standingsLists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StandingsTableModel() when $default != null:
return $default(_that.standingsLists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'StandingsLists')  List<StandingsListsModel> standingsLists)  $default,) {final _that = this;
switch (_that) {
case _StandingsTableModel():
return $default(_that.standingsLists);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'StandingsLists')  List<StandingsListsModel> standingsLists)?  $default,) {final _that = this;
switch (_that) {
case _StandingsTableModel() when $default != null:
return $default(_that.standingsLists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StandingsTableModel implements StandingsTableModel {
  const _StandingsTableModel({@JsonKey(name: 'StandingsLists') required final  List<StandingsListsModel> standingsLists}): _standingsLists = standingsLists;
  factory _StandingsTableModel.fromJson(Map<String, dynamic> json) => _$StandingsTableModelFromJson(json);

 final  List<StandingsListsModel> _standingsLists;
@override@JsonKey(name: 'StandingsLists') List<StandingsListsModel> get standingsLists {
  if (_standingsLists is EqualUnmodifiableListView) return _standingsLists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_standingsLists);
}


/// Create a copy of StandingsTableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StandingsTableModelCopyWith<_StandingsTableModel> get copyWith => __$StandingsTableModelCopyWithImpl<_StandingsTableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StandingsTableModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StandingsTableModel&&const DeepCollectionEquality().equals(other._standingsLists, _standingsLists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_standingsLists));

@override
String toString() {
  return 'StandingsTableModel(standingsLists: $standingsLists)';
}


}

/// @nodoc
abstract mixin class _$StandingsTableModelCopyWith<$Res> implements $StandingsTableModelCopyWith<$Res> {
  factory _$StandingsTableModelCopyWith(_StandingsTableModel value, $Res Function(_StandingsTableModel) _then) = __$StandingsTableModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'StandingsLists') List<StandingsListsModel> standingsLists
});




}
/// @nodoc
class __$StandingsTableModelCopyWithImpl<$Res>
    implements _$StandingsTableModelCopyWith<$Res> {
  __$StandingsTableModelCopyWithImpl(this._self, this._then);

  final _StandingsTableModel _self;
  final $Res Function(_StandingsTableModel) _then;

/// Create a copy of StandingsTableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? standingsLists = null,}) {
  return _then(_StandingsTableModel(
standingsLists: null == standingsLists ? _self._standingsLists : standingsLists // ignore: cast_nullable_to_non_nullable
as List<StandingsListsModel>,
  ));
}


}

// dart format on
