// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'race_table_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RaceTableModel {

/// В ответах `circuits/.../results` season на уровне таблицы отсутствует.
@JsonKey(defaultValue: '') String get season;@JsonKey(name: 'Races') List<RacesModel> get races; String? get round;
/// Create a copy of RaceTableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RaceTableModelCopyWith<RaceTableModel> get copyWith => _$RaceTableModelCopyWithImpl<RaceTableModel>(this as RaceTableModel, _$identity);

  /// Serializes this RaceTableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RaceTableModel&&(identical(other.season, season) || other.season == season)&&const DeepCollectionEquality().equals(other.races, races)&&(identical(other.round, round) || other.round == round));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,const DeepCollectionEquality().hash(races),round);



}

/// @nodoc
abstract mixin class $RaceTableModelCopyWith<$Res>  {
  factory $RaceTableModelCopyWith(RaceTableModel value, $Res Function(RaceTableModel) _then) = _$RaceTableModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String season,@JsonKey(name: 'Races') List<RacesModel> races, String? round
});




}
/// @nodoc
class _$RaceTableModelCopyWithImpl<$Res>
    implements $RaceTableModelCopyWith<$Res> {
  _$RaceTableModelCopyWithImpl(this._self, this._then);

  final RaceTableModel _self;
  final $Res Function(RaceTableModel) _then;

/// Create a copy of RaceTableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? season = null,Object? races = null,Object? round = freezed,}) {
  return _then(_self.copyWith(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,races: null == races ? _self.races : races // ignore: cast_nullable_to_non_nullable
as List<RacesModel>,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RaceTableModel].
extension RaceTableModelPatterns on RaceTableModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RaceTableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RaceTableModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RaceTableModel value)  $default,){
final _that = this;
switch (_that) {
case _RaceTableModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RaceTableModel value)?  $default,){
final _that = this;
switch (_that) {
case _RaceTableModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String season, @JsonKey(name: 'Races')  List<RacesModel> races,  String? round)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RaceTableModel() when $default != null:
return $default(_that.season,_that.races,_that.round);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String season, @JsonKey(name: 'Races')  List<RacesModel> races,  String? round)  $default,) {final _that = this;
switch (_that) {
case _RaceTableModel():
return $default(_that.season,_that.races,_that.round);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String season, @JsonKey(name: 'Races')  List<RacesModel> races,  String? round)?  $default,) {final _that = this;
switch (_that) {
case _RaceTableModel() when $default != null:
return $default(_that.season,_that.races,_that.round);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RaceTableModel extends RaceTableModel {
  const _RaceTableModel({@JsonKey(defaultValue: '') required this.season, @JsonKey(name: 'Races') required final  List<RacesModel> races, this.round}): _races = races,super._();
  factory _RaceTableModel.fromJson(Map<String, dynamic> json) => _$RaceTableModelFromJson(json);

/// В ответах `circuits/.../results` season на уровне таблицы отсутствует.
@override@JsonKey(defaultValue: '') final  String season;
 final  List<RacesModel> _races;
@override@JsonKey(name: 'Races') List<RacesModel> get races {
  if (_races is EqualUnmodifiableListView) return _races;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_races);
}

@override final  String? round;

/// Create a copy of RaceTableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RaceTableModelCopyWith<_RaceTableModel> get copyWith => __$RaceTableModelCopyWithImpl<_RaceTableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RaceTableModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RaceTableModel&&(identical(other.season, season) || other.season == season)&&const DeepCollectionEquality().equals(other._races, _races)&&(identical(other.round, round) || other.round == round));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,const DeepCollectionEquality().hash(_races),round);



}

/// @nodoc
abstract mixin class _$RaceTableModelCopyWith<$Res> implements $RaceTableModelCopyWith<$Res> {
  factory _$RaceTableModelCopyWith(_RaceTableModel value, $Res Function(_RaceTableModel) _then) = __$RaceTableModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String season,@JsonKey(name: 'Races') List<RacesModel> races, String? round
});




}
/// @nodoc
class __$RaceTableModelCopyWithImpl<$Res>
    implements _$RaceTableModelCopyWith<$Res> {
  __$RaceTableModelCopyWithImpl(this._self, this._then);

  final _RaceTableModel _self;
  final $Res Function(_RaceTableModel) _then;

/// Create a copy of RaceTableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? season = null,Object? races = null,Object? round = freezed,}) {
  return _then(_RaceTableModel(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,races: null == races ? _self._races : races // ignore: cast_nullable_to_non_nullable
as List<RacesModel>,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
