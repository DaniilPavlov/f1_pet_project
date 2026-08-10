// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_rewind_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeasonRewindPageViewModel {

 Loadable<List<RacesModel>> get races; Loadable<List<StandingsListsModel>> get driversStandings; Loadable<List<StandingsListsModel>> get constructorsStandings; int get selectedRoundIndex; bool get isPlaying; List<DriverStandingsModel> get chartDrivers; List<ConstructorStandingsModel> get chartConstructors; String? get chartRound; bool get chartLoading;
/// Create a copy of SeasonRewindPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonRewindPageViewModelCopyWith<SeasonRewindPageViewModel> get copyWith => _$SeasonRewindPageViewModelCopyWithImpl<SeasonRewindPageViewModel>(this as SeasonRewindPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonRewindPageViewModel&&(identical(other.races, races) || other.races == races)&&(identical(other.driversStandings, driversStandings) || other.driversStandings == driversStandings)&&(identical(other.constructorsStandings, constructorsStandings) || other.constructorsStandings == constructorsStandings)&&(identical(other.selectedRoundIndex, selectedRoundIndex) || other.selectedRoundIndex == selectedRoundIndex)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&const DeepCollectionEquality().equals(other.chartDrivers, chartDrivers)&&const DeepCollectionEquality().equals(other.chartConstructors, chartConstructors)&&(identical(other.chartRound, chartRound) || other.chartRound == chartRound)&&(identical(other.chartLoading, chartLoading) || other.chartLoading == chartLoading));
}


@override
int get hashCode => Object.hash(runtimeType,races,driversStandings,constructorsStandings,selectedRoundIndex,isPlaying,const DeepCollectionEquality().hash(chartDrivers),const DeepCollectionEquality().hash(chartConstructors),chartRound,chartLoading);

@override
String toString() {
  return 'SeasonRewindPageViewModel(races: $races, driversStandings: $driversStandings, constructorsStandings: $constructorsStandings, selectedRoundIndex: $selectedRoundIndex, isPlaying: $isPlaying, chartDrivers: $chartDrivers, chartConstructors: $chartConstructors, chartRound: $chartRound, chartLoading: $chartLoading)';
}


}

/// @nodoc
abstract mixin class $SeasonRewindPageViewModelCopyWith<$Res>  {
  factory $SeasonRewindPageViewModelCopyWith(SeasonRewindPageViewModel value, $Res Function(SeasonRewindPageViewModel) _then) = _$SeasonRewindPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<List<RacesModel>> races, Loadable<List<StandingsListsModel>> driversStandings, Loadable<List<StandingsListsModel>> constructorsStandings, int selectedRoundIndex, bool isPlaying, List<DriverStandingsModel> chartDrivers, List<ConstructorStandingsModel> chartConstructors, String? chartRound, bool chartLoading
});




}
/// @nodoc
class _$SeasonRewindPageViewModelCopyWithImpl<$Res>
    implements $SeasonRewindPageViewModelCopyWith<$Res> {
  _$SeasonRewindPageViewModelCopyWithImpl(this._self, this._then);

  final SeasonRewindPageViewModel _self;
  final $Res Function(SeasonRewindPageViewModel) _then;

/// Create a copy of SeasonRewindPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? races = null,Object? driversStandings = null,Object? constructorsStandings = null,Object? selectedRoundIndex = null,Object? isPlaying = null,Object? chartDrivers = null,Object? chartConstructors = null,Object? chartRound = freezed,Object? chartLoading = null,}) {
  return _then(_self.copyWith(
races: null == races ? _self.races : races // ignore: cast_nullable_to_non_nullable
as Loadable<List<RacesModel>>,driversStandings: null == driversStandings ? _self.driversStandings : driversStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,constructorsStandings: null == constructorsStandings ? _self.constructorsStandings : constructorsStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,selectedRoundIndex: null == selectedRoundIndex ? _self.selectedRoundIndex : selectedRoundIndex // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,chartDrivers: null == chartDrivers ? _self.chartDrivers : chartDrivers // ignore: cast_nullable_to_non_nullable
as List<DriverStandingsModel>,chartConstructors: null == chartConstructors ? _self.chartConstructors : chartConstructors // ignore: cast_nullable_to_non_nullable
as List<ConstructorStandingsModel>,chartRound: freezed == chartRound ? _self.chartRound : chartRound // ignore: cast_nullable_to_non_nullable
as String?,chartLoading: null == chartLoading ? _self.chartLoading : chartLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonRewindPageViewModel].
extension SeasonRewindPageViewModelPatterns on SeasonRewindPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonRewindPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonRewindPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonRewindPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _SeasonRewindPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonRewindPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonRewindPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<List<RacesModel>> races,  Loadable<List<StandingsListsModel>> driversStandings,  Loadable<List<StandingsListsModel>> constructorsStandings,  int selectedRoundIndex,  bool isPlaying,  List<DriverStandingsModel> chartDrivers,  List<ConstructorStandingsModel> chartConstructors,  String? chartRound,  bool chartLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonRewindPageViewModel() when $default != null:
return $default(_that.races,_that.driversStandings,_that.constructorsStandings,_that.selectedRoundIndex,_that.isPlaying,_that.chartDrivers,_that.chartConstructors,_that.chartRound,_that.chartLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<List<RacesModel>> races,  Loadable<List<StandingsListsModel>> driversStandings,  Loadable<List<StandingsListsModel>> constructorsStandings,  int selectedRoundIndex,  bool isPlaying,  List<DriverStandingsModel> chartDrivers,  List<ConstructorStandingsModel> chartConstructors,  String? chartRound,  bool chartLoading)  $default,) {final _that = this;
switch (_that) {
case _SeasonRewindPageViewModel():
return $default(_that.races,_that.driversStandings,_that.constructorsStandings,_that.selectedRoundIndex,_that.isPlaying,_that.chartDrivers,_that.chartConstructors,_that.chartRound,_that.chartLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<List<RacesModel>> races,  Loadable<List<StandingsListsModel>> driversStandings,  Loadable<List<StandingsListsModel>> constructorsStandings,  int selectedRoundIndex,  bool isPlaying,  List<DriverStandingsModel> chartDrivers,  List<ConstructorStandingsModel> chartConstructors,  String? chartRound,  bool chartLoading)?  $default,) {final _that = this;
switch (_that) {
case _SeasonRewindPageViewModel() when $default != null:
return $default(_that.races,_that.driversStandings,_that.constructorsStandings,_that.selectedRoundIndex,_that.isPlaying,_that.chartDrivers,_that.chartConstructors,_that.chartRound,_that.chartLoading);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonRewindPageViewModel extends SeasonRewindPageViewModel {
  const _SeasonRewindPageViewModel({this.races = const Loadable.loading(), this.driversStandings = const Loadable.loading(), this.constructorsStandings = const Loadable.loading(), this.selectedRoundIndex = 0, this.isPlaying = false, final  List<DriverStandingsModel> chartDrivers = const [], final  List<ConstructorStandingsModel> chartConstructors = const [], this.chartRound, this.chartLoading = false}): _chartDrivers = chartDrivers,_chartConstructors = chartConstructors,super._();
  

@override@JsonKey() final  Loadable<List<RacesModel>> races;
@override@JsonKey() final  Loadable<List<StandingsListsModel>> driversStandings;
@override@JsonKey() final  Loadable<List<StandingsListsModel>> constructorsStandings;
@override@JsonKey() final  int selectedRoundIndex;
@override@JsonKey() final  bool isPlaying;
 final  List<DriverStandingsModel> _chartDrivers;
@override@JsonKey() List<DriverStandingsModel> get chartDrivers {
  if (_chartDrivers is EqualUnmodifiableListView) return _chartDrivers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chartDrivers);
}

 final  List<ConstructorStandingsModel> _chartConstructors;
@override@JsonKey() List<ConstructorStandingsModel> get chartConstructors {
  if (_chartConstructors is EqualUnmodifiableListView) return _chartConstructors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chartConstructors);
}

@override final  String? chartRound;
@override@JsonKey() final  bool chartLoading;

/// Create a copy of SeasonRewindPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonRewindPageViewModelCopyWith<_SeasonRewindPageViewModel> get copyWith => __$SeasonRewindPageViewModelCopyWithImpl<_SeasonRewindPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonRewindPageViewModel&&(identical(other.races, races) || other.races == races)&&(identical(other.driversStandings, driversStandings) || other.driversStandings == driversStandings)&&(identical(other.constructorsStandings, constructorsStandings) || other.constructorsStandings == constructorsStandings)&&(identical(other.selectedRoundIndex, selectedRoundIndex) || other.selectedRoundIndex == selectedRoundIndex)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&const DeepCollectionEquality().equals(other._chartDrivers, _chartDrivers)&&const DeepCollectionEquality().equals(other._chartConstructors, _chartConstructors)&&(identical(other.chartRound, chartRound) || other.chartRound == chartRound)&&(identical(other.chartLoading, chartLoading) || other.chartLoading == chartLoading));
}


@override
int get hashCode => Object.hash(runtimeType,races,driversStandings,constructorsStandings,selectedRoundIndex,isPlaying,const DeepCollectionEquality().hash(_chartDrivers),const DeepCollectionEquality().hash(_chartConstructors),chartRound,chartLoading);

@override
String toString() {
  return 'SeasonRewindPageViewModel(races: $races, driversStandings: $driversStandings, constructorsStandings: $constructorsStandings, selectedRoundIndex: $selectedRoundIndex, isPlaying: $isPlaying, chartDrivers: $chartDrivers, chartConstructors: $chartConstructors, chartRound: $chartRound, chartLoading: $chartLoading)';
}


}

/// @nodoc
abstract mixin class _$SeasonRewindPageViewModelCopyWith<$Res> implements $SeasonRewindPageViewModelCopyWith<$Res> {
  factory _$SeasonRewindPageViewModelCopyWith(_SeasonRewindPageViewModel value, $Res Function(_SeasonRewindPageViewModel) _then) = __$SeasonRewindPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<List<RacesModel>> races, Loadable<List<StandingsListsModel>> driversStandings, Loadable<List<StandingsListsModel>> constructorsStandings, int selectedRoundIndex, bool isPlaying, List<DriverStandingsModel> chartDrivers, List<ConstructorStandingsModel> chartConstructors, String? chartRound, bool chartLoading
});




}
/// @nodoc
class __$SeasonRewindPageViewModelCopyWithImpl<$Res>
    implements _$SeasonRewindPageViewModelCopyWith<$Res> {
  __$SeasonRewindPageViewModelCopyWithImpl(this._self, this._then);

  final _SeasonRewindPageViewModel _self;
  final $Res Function(_SeasonRewindPageViewModel) _then;

/// Create a copy of SeasonRewindPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? races = null,Object? driversStandings = null,Object? constructorsStandings = null,Object? selectedRoundIndex = null,Object? isPlaying = null,Object? chartDrivers = null,Object? chartConstructors = null,Object? chartRound = freezed,Object? chartLoading = null,}) {
  return _then(_SeasonRewindPageViewModel(
races: null == races ? _self.races : races // ignore: cast_nullable_to_non_nullable
as Loadable<List<RacesModel>>,driversStandings: null == driversStandings ? _self.driversStandings : driversStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,constructorsStandings: null == constructorsStandings ? _self.constructorsStandings : constructorsStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,selectedRoundIndex: null == selectedRoundIndex ? _self.selectedRoundIndex : selectedRoundIndex // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,chartDrivers: null == chartDrivers ? _self._chartDrivers : chartDrivers // ignore: cast_nullable_to_non_nullable
as List<DriverStandingsModel>,chartConstructors: null == chartConstructors ? _self._chartConstructors : chartConstructors // ignore: cast_nullable_to_non_nullable
as List<ConstructorStandingsModel>,chartRound: freezed == chartRound ? _self.chartRound : chartRound // ignore: cast_nullable_to_non_nullable
as String?,chartLoading: null == chartLoading ? _self.chartLoading : chartLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
