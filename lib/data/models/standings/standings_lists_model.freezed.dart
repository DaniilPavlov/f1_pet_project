// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'standings_lists_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StandingsListsModel {

 String get season; String get round;@JsonKey(name: 'ConstructorStandings') List<ConstructorStandingsModel>? get constructorStandings;@JsonKey(name: 'DriverStandings') List<DriverStandingsModel>? get driverStandings;
/// Create a copy of StandingsListsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StandingsListsModelCopyWith<StandingsListsModel> get copyWith => _$StandingsListsModelCopyWithImpl<StandingsListsModel>(this as StandingsListsModel, _$identity);

  /// Serializes this StandingsListsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StandingsListsModel&&(identical(other.season, season) || other.season == season)&&(identical(other.round, round) || other.round == round)&&const DeepCollectionEquality().equals(other.constructorStandings, constructorStandings)&&const DeepCollectionEquality().equals(other.driverStandings, driverStandings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,round,const DeepCollectionEquality().hash(constructorStandings),const DeepCollectionEquality().hash(driverStandings));

@override
String toString() {
  return 'StandingsListsModel(season: $season, round: $round, constructorStandings: $constructorStandings, driverStandings: $driverStandings)';
}


}

/// @nodoc
abstract mixin class $StandingsListsModelCopyWith<$Res>  {
  factory $StandingsListsModelCopyWith(StandingsListsModel value, $Res Function(StandingsListsModel) _then) = _$StandingsListsModelCopyWithImpl;
@useResult
$Res call({
 String season, String round,@JsonKey(name: 'ConstructorStandings') List<ConstructorStandingsModel>? constructorStandings,@JsonKey(name: 'DriverStandings') List<DriverStandingsModel>? driverStandings
});




}
/// @nodoc
class _$StandingsListsModelCopyWithImpl<$Res>
    implements $StandingsListsModelCopyWith<$Res> {
  _$StandingsListsModelCopyWithImpl(this._self, this._then);

  final StandingsListsModel _self;
  final $Res Function(StandingsListsModel) _then;

/// Create a copy of StandingsListsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? season = null,Object? round = null,Object? constructorStandings = freezed,Object? driverStandings = freezed,}) {
  return _then(_self.copyWith(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as String,constructorStandings: freezed == constructorStandings ? _self.constructorStandings : constructorStandings // ignore: cast_nullable_to_non_nullable
as List<ConstructorStandingsModel>?,driverStandings: freezed == driverStandings ? _self.driverStandings : driverStandings // ignore: cast_nullable_to_non_nullable
as List<DriverStandingsModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StandingsListsModel].
extension StandingsListsModelPatterns on StandingsListsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StandingsListsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StandingsListsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StandingsListsModel value)  $default,){
final _that = this;
switch (_that) {
case _StandingsListsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StandingsListsModel value)?  $default,){
final _that = this;
switch (_that) {
case _StandingsListsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String season,  String round, @JsonKey(name: 'ConstructorStandings')  List<ConstructorStandingsModel>? constructorStandings, @JsonKey(name: 'DriverStandings')  List<DriverStandingsModel>? driverStandings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StandingsListsModel() when $default != null:
return $default(_that.season,_that.round,_that.constructorStandings,_that.driverStandings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String season,  String round, @JsonKey(name: 'ConstructorStandings')  List<ConstructorStandingsModel>? constructorStandings, @JsonKey(name: 'DriverStandings')  List<DriverStandingsModel>? driverStandings)  $default,) {final _that = this;
switch (_that) {
case _StandingsListsModel():
return $default(_that.season,_that.round,_that.constructorStandings,_that.driverStandings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String season,  String round, @JsonKey(name: 'ConstructorStandings')  List<ConstructorStandingsModel>? constructorStandings, @JsonKey(name: 'DriverStandings')  List<DriverStandingsModel>? driverStandings)?  $default,) {final _that = this;
switch (_that) {
case _StandingsListsModel() when $default != null:
return $default(_that.season,_that.round,_that.constructorStandings,_that.driverStandings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StandingsListsModel implements StandingsListsModel {
  const _StandingsListsModel({required this.season, required this.round, @JsonKey(name: 'ConstructorStandings') final  List<ConstructorStandingsModel>? constructorStandings, @JsonKey(name: 'DriverStandings') final  List<DriverStandingsModel>? driverStandings}): _constructorStandings = constructorStandings,_driverStandings = driverStandings;
  factory _StandingsListsModel.fromJson(Map<String, dynamic> json) => _$StandingsListsModelFromJson(json);

@override final  String season;
@override final  String round;
 final  List<ConstructorStandingsModel>? _constructorStandings;
@override@JsonKey(name: 'ConstructorStandings') List<ConstructorStandingsModel>? get constructorStandings {
  final value = _constructorStandings;
  if (value == null) return null;
  if (_constructorStandings is EqualUnmodifiableListView) return _constructorStandings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DriverStandingsModel>? _driverStandings;
@override@JsonKey(name: 'DriverStandings') List<DriverStandingsModel>? get driverStandings {
  final value = _driverStandings;
  if (value == null) return null;
  if (_driverStandings is EqualUnmodifiableListView) return _driverStandings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StandingsListsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StandingsListsModelCopyWith<_StandingsListsModel> get copyWith => __$StandingsListsModelCopyWithImpl<_StandingsListsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StandingsListsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StandingsListsModel&&(identical(other.season, season) || other.season == season)&&(identical(other.round, round) || other.round == round)&&const DeepCollectionEquality().equals(other._constructorStandings, _constructorStandings)&&const DeepCollectionEquality().equals(other._driverStandings, _driverStandings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,round,const DeepCollectionEquality().hash(_constructorStandings),const DeepCollectionEquality().hash(_driverStandings));

@override
String toString() {
  return 'StandingsListsModel(season: $season, round: $round, constructorStandings: $constructorStandings, driverStandings: $driverStandings)';
}


}

/// @nodoc
abstract mixin class _$StandingsListsModelCopyWith<$Res> implements $StandingsListsModelCopyWith<$Res> {
  factory _$StandingsListsModelCopyWith(_StandingsListsModel value, $Res Function(_StandingsListsModel) _then) = __$StandingsListsModelCopyWithImpl;
@override @useResult
$Res call({
 String season, String round,@JsonKey(name: 'ConstructorStandings') List<ConstructorStandingsModel>? constructorStandings,@JsonKey(name: 'DriverStandings') List<DriverStandingsModel>? driverStandings
});




}
/// @nodoc
class __$StandingsListsModelCopyWithImpl<$Res>
    implements _$StandingsListsModelCopyWith<$Res> {
  __$StandingsListsModelCopyWithImpl(this._self, this._then);

  final _StandingsListsModel _self;
  final $Res Function(_StandingsListsModel) _then;

/// Create a copy of StandingsListsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? season = null,Object? round = null,Object? constructorStandings = freezed,Object? driverStandings = freezed,}) {
  return _then(_StandingsListsModel(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as String,constructorStandings: freezed == constructorStandings ? _self._constructorStandings : constructorStandings // ignore: cast_nullable_to_non_nullable
as List<ConstructorStandingsModel>?,driverStandings: freezed == driverStandings ? _self._driverStandings : driverStandings // ignore: cast_nullable_to_non_nullable
as List<DriverStandingsModel>?,
  ));
}


}

// dart format on
