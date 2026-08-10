// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_table_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeasonTableModel {

@JsonKey(name: 'Seasons') List<SeasonModel> get seasons;
/// Create a copy of SeasonTableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonTableModelCopyWith<SeasonTableModel> get copyWith => _$SeasonTableModelCopyWithImpl<SeasonTableModel>(this as SeasonTableModel, _$identity);

  /// Serializes this SeasonTableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonTableModel&&const DeepCollectionEquality().equals(other.seasons, seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(seasons));

@override
String toString() {
  return 'SeasonTableModel(seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class $SeasonTableModelCopyWith<$Res>  {
  factory $SeasonTableModelCopyWith(SeasonTableModel value, $Res Function(SeasonTableModel) _then) = _$SeasonTableModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'Seasons') List<SeasonModel> seasons
});




}
/// @nodoc
class _$SeasonTableModelCopyWithImpl<$Res>
    implements $SeasonTableModelCopyWith<$Res> {
  _$SeasonTableModelCopyWithImpl(this._self, this._then);

  final SeasonTableModel _self;
  final $Res Function(SeasonTableModel) _then;

/// Create a copy of SeasonTableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasons = null,}) {
  return _then(_self.copyWith(
seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SeasonModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonTableModel].
extension SeasonTableModelPatterns on SeasonTableModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonTableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonTableModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonTableModel value)  $default,){
final _that = this;
switch (_that) {
case _SeasonTableModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonTableModel value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonTableModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'Seasons')  List<SeasonModel> seasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonTableModel() when $default != null:
return $default(_that.seasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'Seasons')  List<SeasonModel> seasons)  $default,) {final _that = this;
switch (_that) {
case _SeasonTableModel():
return $default(_that.seasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'Seasons')  List<SeasonModel> seasons)?  $default,) {final _that = this;
switch (_that) {
case _SeasonTableModel() when $default != null:
return $default(_that.seasons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeasonTableModel implements SeasonTableModel {
  const _SeasonTableModel({@JsonKey(name: 'Seasons') required final  List<SeasonModel> seasons}): _seasons = seasons;
  factory _SeasonTableModel.fromJson(Map<String, dynamic> json) => _$SeasonTableModelFromJson(json);

 final  List<SeasonModel> _seasons;
@override@JsonKey(name: 'Seasons') List<SeasonModel> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}


/// Create a copy of SeasonTableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonTableModelCopyWith<_SeasonTableModel> get copyWith => __$SeasonTableModelCopyWithImpl<_SeasonTableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonTableModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonTableModel&&const DeepCollectionEquality().equals(other._seasons, _seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_seasons));

@override
String toString() {
  return 'SeasonTableModel(seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class _$SeasonTableModelCopyWith<$Res> implements $SeasonTableModelCopyWith<$Res> {
  factory _$SeasonTableModelCopyWith(_SeasonTableModel value, $Res Function(_SeasonTableModel) _then) = __$SeasonTableModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'Seasons') List<SeasonModel> seasons
});




}
/// @nodoc
class __$SeasonTableModelCopyWithImpl<$Res>
    implements _$SeasonTableModelCopyWith<$Res> {
  __$SeasonTableModelCopyWithImpl(this._self, this._then);

  final _SeasonTableModel _self;
  final $Res Function(_SeasonTableModel) _then;

/// Create a copy of SeasonTableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasons = null,}) {
  return _then(_SeasonTableModel(
seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SeasonModel>,
  ));
}


}

// dart format on
