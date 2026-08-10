// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'race_info_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RaceInfoPageViewModel {

 bool get allDataIsLoaded; Loadable<List<ResultsModel>> get sprintResults; Loadable<List<QualifyingResultsModel>> get qualifyingResults; Loadable<List<PitStopsModel>> get pitStops;
/// Create a copy of RaceInfoPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RaceInfoPageViewModelCopyWith<RaceInfoPageViewModel> get copyWith => _$RaceInfoPageViewModelCopyWithImpl<RaceInfoPageViewModel>(this as RaceInfoPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RaceInfoPageViewModel&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded)&&(identical(other.sprintResults, sprintResults) || other.sprintResults == sprintResults)&&(identical(other.qualifyingResults, qualifyingResults) || other.qualifyingResults == qualifyingResults)&&(identical(other.pitStops, pitStops) || other.pitStops == pitStops));
}


@override
int get hashCode => Object.hash(runtimeType,allDataIsLoaded,sprintResults,qualifyingResults,pitStops);

@override
String toString() {
  return 'RaceInfoPageViewModel(allDataIsLoaded: $allDataIsLoaded, sprintResults: $sprintResults, qualifyingResults: $qualifyingResults, pitStops: $pitStops)';
}


}

/// @nodoc
abstract mixin class $RaceInfoPageViewModelCopyWith<$Res>  {
  factory $RaceInfoPageViewModelCopyWith(RaceInfoPageViewModel value, $Res Function(RaceInfoPageViewModel) _then) = _$RaceInfoPageViewModelCopyWithImpl;
@useResult
$Res call({
 bool allDataIsLoaded, Loadable<List<ResultsModel>> sprintResults, Loadable<List<QualifyingResultsModel>> qualifyingResults, Loadable<List<PitStopsModel>> pitStops
});




}
/// @nodoc
class _$RaceInfoPageViewModelCopyWithImpl<$Res>
    implements $RaceInfoPageViewModelCopyWith<$Res> {
  _$RaceInfoPageViewModelCopyWithImpl(this._self, this._then);

  final RaceInfoPageViewModel _self;
  final $Res Function(RaceInfoPageViewModel) _then;

/// Create a copy of RaceInfoPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allDataIsLoaded = null,Object? sprintResults = null,Object? qualifyingResults = null,Object? pitStops = null,}) {
  return _then(_self.copyWith(
allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,sprintResults: null == sprintResults ? _self.sprintResults : sprintResults // ignore: cast_nullable_to_non_nullable
as Loadable<List<ResultsModel>>,qualifyingResults: null == qualifyingResults ? _self.qualifyingResults : qualifyingResults // ignore: cast_nullable_to_non_nullable
as Loadable<List<QualifyingResultsModel>>,pitStops: null == pitStops ? _self.pitStops : pitStops // ignore: cast_nullable_to_non_nullable
as Loadable<List<PitStopsModel>>,
  ));
}

}


/// Adds pattern-matching-related methods to [RaceInfoPageViewModel].
extension RaceInfoPageViewModelPatterns on RaceInfoPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RaceInfoPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RaceInfoPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RaceInfoPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _RaceInfoPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RaceInfoPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _RaceInfoPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allDataIsLoaded,  Loadable<List<ResultsModel>> sprintResults,  Loadable<List<QualifyingResultsModel>> qualifyingResults,  Loadable<List<PitStopsModel>> pitStops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RaceInfoPageViewModel() when $default != null:
return $default(_that.allDataIsLoaded,_that.sprintResults,_that.qualifyingResults,_that.pitStops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allDataIsLoaded,  Loadable<List<ResultsModel>> sprintResults,  Loadable<List<QualifyingResultsModel>> qualifyingResults,  Loadable<List<PitStopsModel>> pitStops)  $default,) {final _that = this;
switch (_that) {
case _RaceInfoPageViewModel():
return $default(_that.allDataIsLoaded,_that.sprintResults,_that.qualifyingResults,_that.pitStops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allDataIsLoaded,  Loadable<List<ResultsModel>> sprintResults,  Loadable<List<QualifyingResultsModel>> qualifyingResults,  Loadable<List<PitStopsModel>> pitStops)?  $default,) {final _that = this;
switch (_that) {
case _RaceInfoPageViewModel() when $default != null:
return $default(_that.allDataIsLoaded,_that.sprintResults,_that.qualifyingResults,_that.pitStops);case _:
  return null;

}
}

}

/// @nodoc


class _RaceInfoPageViewModel extends RaceInfoPageViewModel {
  const _RaceInfoPageViewModel({this.allDataIsLoaded = false, this.sprintResults = const Loadable.loading(), this.qualifyingResults = const Loadable.loading(), this.pitStops = const Loadable.loading()}): super._();
  

@override@JsonKey() final  bool allDataIsLoaded;
@override@JsonKey() final  Loadable<List<ResultsModel>> sprintResults;
@override@JsonKey() final  Loadable<List<QualifyingResultsModel>> qualifyingResults;
@override@JsonKey() final  Loadable<List<PitStopsModel>> pitStops;

/// Create a copy of RaceInfoPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RaceInfoPageViewModelCopyWith<_RaceInfoPageViewModel> get copyWith => __$RaceInfoPageViewModelCopyWithImpl<_RaceInfoPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RaceInfoPageViewModel&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded)&&(identical(other.sprintResults, sprintResults) || other.sprintResults == sprintResults)&&(identical(other.qualifyingResults, qualifyingResults) || other.qualifyingResults == qualifyingResults)&&(identical(other.pitStops, pitStops) || other.pitStops == pitStops));
}


@override
int get hashCode => Object.hash(runtimeType,allDataIsLoaded,sprintResults,qualifyingResults,pitStops);

@override
String toString() {
  return 'RaceInfoPageViewModel(allDataIsLoaded: $allDataIsLoaded, sprintResults: $sprintResults, qualifyingResults: $qualifyingResults, pitStops: $pitStops)';
}


}

/// @nodoc
abstract mixin class _$RaceInfoPageViewModelCopyWith<$Res> implements $RaceInfoPageViewModelCopyWith<$Res> {
  factory _$RaceInfoPageViewModelCopyWith(_RaceInfoPageViewModel value, $Res Function(_RaceInfoPageViewModel) _then) = __$RaceInfoPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 bool allDataIsLoaded, Loadable<List<ResultsModel>> sprintResults, Loadable<List<QualifyingResultsModel>> qualifyingResults, Loadable<List<PitStopsModel>> pitStops
});




}
/// @nodoc
class __$RaceInfoPageViewModelCopyWithImpl<$Res>
    implements _$RaceInfoPageViewModelCopyWith<$Res> {
  __$RaceInfoPageViewModelCopyWithImpl(this._self, this._then);

  final _RaceInfoPageViewModel _self;
  final $Res Function(_RaceInfoPageViewModel) _then;

/// Create a copy of RaceInfoPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allDataIsLoaded = null,Object? sprintResults = null,Object? qualifyingResults = null,Object? pitStops = null,}) {
  return _then(_RaceInfoPageViewModel(
allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,sprintResults: null == sprintResults ? _self.sprintResults : sprintResults // ignore: cast_nullable_to_non_nullable
as Loadable<List<ResultsModel>>,qualifyingResults: null == qualifyingResults ? _self.qualifyingResults : qualifyingResults // ignore: cast_nullable_to_non_nullable
as Loadable<List<QualifyingResultsModel>>,pitStops: null == pitStops ? _self.pitStops : pitStops // ignore: cast_nullable_to_non_nullable
as Loadable<List<PitStopsModel>>,
  ));
}


}

// dart format on
