// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomePageViewModel {

 Loadable<List<DriverStandingsModel>> get currentDrivers; Loadable<List<ConstructorStandingsModel>> get currentConstructors; String get currentSeason; String get currentRound; bool get showingCachedData;
/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomePageViewModelCopyWith<HomePageViewModel> get copyWith => _$HomePageViewModelCopyWithImpl<HomePageViewModel>(this as HomePageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomePageViewModel&&(identical(other.currentDrivers, currentDrivers) || other.currentDrivers == currentDrivers)&&(identical(other.currentConstructors, currentConstructors) || other.currentConstructors == currentConstructors)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,currentDrivers,currentConstructors,currentSeason,currentRound,showingCachedData);

@override
String toString() {
  return 'HomePageViewModel(currentDrivers: $currentDrivers, currentConstructors: $currentConstructors, currentSeason: $currentSeason, currentRound: $currentRound, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class $HomePageViewModelCopyWith<$Res>  {
  factory $HomePageViewModelCopyWith(HomePageViewModel value, $Res Function(HomePageViewModel) _then) = _$HomePageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<List<DriverStandingsModel>> currentDrivers, Loadable<List<ConstructorStandingsModel>> currentConstructors, String currentSeason, String currentRound, bool showingCachedData
});




}
/// @nodoc
class _$HomePageViewModelCopyWithImpl<$Res>
    implements $HomePageViewModelCopyWith<$Res> {
  _$HomePageViewModelCopyWithImpl(this._self, this._then);

  final HomePageViewModel _self;
  final $Res Function(HomePageViewModel) _then;

/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentDrivers = null,Object? currentConstructors = null,Object? currentSeason = null,Object? currentRound = null,Object? showingCachedData = null,}) {
  return _then(_self.copyWith(
currentDrivers: null == currentDrivers ? _self.currentDrivers : currentDrivers // ignore: cast_nullable_to_non_nullable
as Loadable<List<DriverStandingsModel>>,currentConstructors: null == currentConstructors ? _self.currentConstructors : currentConstructors // ignore: cast_nullable_to_non_nullable
as Loadable<List<ConstructorStandingsModel>>,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as String,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as String,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HomePageViewModel].
extension HomePageViewModelPatterns on HomePageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomePageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomePageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _HomePageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomePageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<List<DriverStandingsModel>> currentDrivers,  Loadable<List<ConstructorStandingsModel>> currentConstructors,  String currentSeason,  String currentRound,  bool showingCachedData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
return $default(_that.currentDrivers,_that.currentConstructors,_that.currentSeason,_that.currentRound,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<List<DriverStandingsModel>> currentDrivers,  Loadable<List<ConstructorStandingsModel>> currentConstructors,  String currentSeason,  String currentRound,  bool showingCachedData)  $default,) {final _that = this;
switch (_that) {
case _HomePageViewModel():
return $default(_that.currentDrivers,_that.currentConstructors,_that.currentSeason,_that.currentRound,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<List<DriverStandingsModel>> currentDrivers,  Loadable<List<ConstructorStandingsModel>> currentConstructors,  String currentSeason,  String currentRound,  bool showingCachedData)?  $default,) {final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
return $default(_that.currentDrivers,_that.currentConstructors,_that.currentSeason,_that.currentRound,_that.showingCachedData);case _:
  return null;

}
}

}

/// @nodoc


class _HomePageViewModel extends HomePageViewModel {
  const _HomePageViewModel({this.currentDrivers = const Loadable.loading(), this.currentConstructors = const Loadable.loading(), this.currentSeason = '', this.currentRound = '', this.showingCachedData = false}): super._();
  

@override@JsonKey() final  Loadable<List<DriverStandingsModel>> currentDrivers;
@override@JsonKey() final  Loadable<List<ConstructorStandingsModel>> currentConstructors;
@override@JsonKey() final  String currentSeason;
@override@JsonKey() final  String currentRound;
@override@JsonKey() final  bool showingCachedData;

/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomePageViewModelCopyWith<_HomePageViewModel> get copyWith => __$HomePageViewModelCopyWithImpl<_HomePageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomePageViewModel&&(identical(other.currentDrivers, currentDrivers) || other.currentDrivers == currentDrivers)&&(identical(other.currentConstructors, currentConstructors) || other.currentConstructors == currentConstructors)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,currentDrivers,currentConstructors,currentSeason,currentRound,showingCachedData);

@override
String toString() {
  return 'HomePageViewModel(currentDrivers: $currentDrivers, currentConstructors: $currentConstructors, currentSeason: $currentSeason, currentRound: $currentRound, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class _$HomePageViewModelCopyWith<$Res> implements $HomePageViewModelCopyWith<$Res> {
  factory _$HomePageViewModelCopyWith(_HomePageViewModel value, $Res Function(_HomePageViewModel) _then) = __$HomePageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<List<DriverStandingsModel>> currentDrivers, Loadable<List<ConstructorStandingsModel>> currentConstructors, String currentSeason, String currentRound, bool showingCachedData
});




}
/// @nodoc
class __$HomePageViewModelCopyWithImpl<$Res>
    implements _$HomePageViewModelCopyWith<$Res> {
  __$HomePageViewModelCopyWithImpl(this._self, this._then);

  final _HomePageViewModel _self;
  final $Res Function(_HomePageViewModel) _then;

/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentDrivers = null,Object? currentConstructors = null,Object? currentSeason = null,Object? currentRound = null,Object? showingCachedData = null,}) {
  return _then(_HomePageViewModel(
currentDrivers: null == currentDrivers ? _self.currentDrivers : currentDrivers // ignore: cast_nullable_to_non_nullable
as Loadable<List<DriverStandingsModel>>,currentConstructors: null == currentConstructors ? _self.currentConstructors : currentConstructors // ignore: cast_nullable_to_non_nullable
as Loadable<List<ConstructorStandingsModel>>,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as String,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as String,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
