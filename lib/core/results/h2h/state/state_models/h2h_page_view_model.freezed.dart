// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'h2h_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$H2hPageViewModel {

 H2hMode get mode;/// 0 — карьера, 1 — сезон.
 int get scopeMode;/// В режиме сезона: true — актуальный год, false — выбор года.
 bool get useCurrentSeason;/// true — только current entities, false — полный каталог.
 bool get currentEntitiesOnly; String get latestSeason; bool get seasonSelected; DriverModel? get driverA; DriverModel? get driverB; ConstructorModel? get constructorA; ConstructorModel? get constructorB; Loadable<H2hCompareResult?> get comparison;
/// Create a copy of H2hPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$H2hPageViewModelCopyWith<H2hPageViewModel> get copyWith => _$H2hPageViewModelCopyWithImpl<H2hPageViewModel>(this as H2hPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is H2hPageViewModel&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.scopeMode, scopeMode) || other.scopeMode == scopeMode)&&(identical(other.useCurrentSeason, useCurrentSeason) || other.useCurrentSeason == useCurrentSeason)&&(identical(other.currentEntitiesOnly, currentEntitiesOnly) || other.currentEntitiesOnly == currentEntitiesOnly)&&(identical(other.latestSeason, latestSeason) || other.latestSeason == latestSeason)&&(identical(other.seasonSelected, seasonSelected) || other.seasonSelected == seasonSelected)&&(identical(other.driverA, driverA) || other.driverA == driverA)&&(identical(other.driverB, driverB) || other.driverB == driverB)&&(identical(other.constructorA, constructorA) || other.constructorA == constructorA)&&(identical(other.constructorB, constructorB) || other.constructorB == constructorB)&&(identical(other.comparison, comparison) || other.comparison == comparison));
}


@override
int get hashCode => Object.hash(runtimeType,mode,scopeMode,useCurrentSeason,currentEntitiesOnly,latestSeason,seasonSelected,driverA,driverB,constructorA,constructorB,comparison);

@override
String toString() {
  return 'H2hPageViewModel(mode: $mode, scopeMode: $scopeMode, useCurrentSeason: $useCurrentSeason, currentEntitiesOnly: $currentEntitiesOnly, latestSeason: $latestSeason, seasonSelected: $seasonSelected, driverA: $driverA, driverB: $driverB, constructorA: $constructorA, constructorB: $constructorB, comparison: $comparison)';
}


}

/// @nodoc
abstract mixin class $H2hPageViewModelCopyWith<$Res>  {
  factory $H2hPageViewModelCopyWith(H2hPageViewModel value, $Res Function(H2hPageViewModel) _then) = _$H2hPageViewModelCopyWithImpl;
@useResult
$Res call({
 H2hMode mode, int scopeMode, bool useCurrentSeason, bool currentEntitiesOnly, String latestSeason, bool seasonSelected, DriverModel? driverA, DriverModel? driverB, ConstructorModel? constructorA, ConstructorModel? constructorB, Loadable<H2hCompareResult?> comparison
});




}
/// @nodoc
class _$H2hPageViewModelCopyWithImpl<$Res>
    implements $H2hPageViewModelCopyWith<$Res> {
  _$H2hPageViewModelCopyWithImpl(this._self, this._then);

  final H2hPageViewModel _self;
  final $Res Function(H2hPageViewModel) _then;

/// Create a copy of H2hPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? scopeMode = null,Object? useCurrentSeason = null,Object? currentEntitiesOnly = null,Object? latestSeason = null,Object? seasonSelected = null,Object? driverA = freezed,Object? driverB = freezed,Object? constructorA = freezed,Object? constructorB = freezed,Object? comparison = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as H2hMode,scopeMode: null == scopeMode ? _self.scopeMode : scopeMode // ignore: cast_nullable_to_non_nullable
as int,useCurrentSeason: null == useCurrentSeason ? _self.useCurrentSeason : useCurrentSeason // ignore: cast_nullable_to_non_nullable
as bool,currentEntitiesOnly: null == currentEntitiesOnly ? _self.currentEntitiesOnly : currentEntitiesOnly // ignore: cast_nullable_to_non_nullable
as bool,latestSeason: null == latestSeason ? _self.latestSeason : latestSeason // ignore: cast_nullable_to_non_nullable
as String,seasonSelected: null == seasonSelected ? _self.seasonSelected : seasonSelected // ignore: cast_nullable_to_non_nullable
as bool,driverA: freezed == driverA ? _self.driverA : driverA // ignore: cast_nullable_to_non_nullable
as DriverModel?,driverB: freezed == driverB ? _self.driverB : driverB // ignore: cast_nullable_to_non_nullable
as DriverModel?,constructorA: freezed == constructorA ? _self.constructorA : constructorA // ignore: cast_nullable_to_non_nullable
as ConstructorModel?,constructorB: freezed == constructorB ? _self.constructorB : constructorB // ignore: cast_nullable_to_non_nullable
as ConstructorModel?,comparison: null == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as Loadable<H2hCompareResult?>,
  ));
}

}


/// Adds pattern-matching-related methods to [H2hPageViewModel].
extension H2hPageViewModelPatterns on H2hPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _H2hPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _H2hPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _H2hPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _H2hPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _H2hPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _H2hPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( H2hMode mode,  int scopeMode,  bool useCurrentSeason,  bool currentEntitiesOnly,  String latestSeason,  bool seasonSelected,  DriverModel? driverA,  DriverModel? driverB,  ConstructorModel? constructorA,  ConstructorModel? constructorB,  Loadable<H2hCompareResult?> comparison)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _H2hPageViewModel() when $default != null:
return $default(_that.mode,_that.scopeMode,_that.useCurrentSeason,_that.currentEntitiesOnly,_that.latestSeason,_that.seasonSelected,_that.driverA,_that.driverB,_that.constructorA,_that.constructorB,_that.comparison);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( H2hMode mode,  int scopeMode,  bool useCurrentSeason,  bool currentEntitiesOnly,  String latestSeason,  bool seasonSelected,  DriverModel? driverA,  DriverModel? driverB,  ConstructorModel? constructorA,  ConstructorModel? constructorB,  Loadable<H2hCompareResult?> comparison)  $default,) {final _that = this;
switch (_that) {
case _H2hPageViewModel():
return $default(_that.mode,_that.scopeMode,_that.useCurrentSeason,_that.currentEntitiesOnly,_that.latestSeason,_that.seasonSelected,_that.driverA,_that.driverB,_that.constructorA,_that.constructorB,_that.comparison);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( H2hMode mode,  int scopeMode,  bool useCurrentSeason,  bool currentEntitiesOnly,  String latestSeason,  bool seasonSelected,  DriverModel? driverA,  DriverModel? driverB,  ConstructorModel? constructorA,  ConstructorModel? constructorB,  Loadable<H2hCompareResult?> comparison)?  $default,) {final _that = this;
switch (_that) {
case _H2hPageViewModel() when $default != null:
return $default(_that.mode,_that.scopeMode,_that.useCurrentSeason,_that.currentEntitiesOnly,_that.latestSeason,_that.seasonSelected,_that.driverA,_that.driverB,_that.constructorA,_that.constructorB,_that.comparison);case _:
  return null;

}
}

}

/// @nodoc


class _H2hPageViewModel extends H2hPageViewModel {
  const _H2hPageViewModel({this.mode = H2hMode.drivers, this.scopeMode = 0, this.useCurrentSeason = true, this.currentEntitiesOnly = true, this.latestSeason = '', this.seasonSelected = false, this.driverA, this.driverB, this.constructorA, this.constructorB, this.comparison = const Loadable.value()}): super._();
  

@override@JsonKey() final  H2hMode mode;
/// 0 — карьера, 1 — сезон.
@override@JsonKey() final  int scopeMode;
/// В режиме сезона: true — актуальный год, false — выбор года.
@override@JsonKey() final  bool useCurrentSeason;
/// true — только current entities, false — полный каталог.
@override@JsonKey() final  bool currentEntitiesOnly;
@override@JsonKey() final  String latestSeason;
@override@JsonKey() final  bool seasonSelected;
@override final  DriverModel? driverA;
@override final  DriverModel? driverB;
@override final  ConstructorModel? constructorA;
@override final  ConstructorModel? constructorB;
@override@JsonKey() final  Loadable<H2hCompareResult?> comparison;

/// Create a copy of H2hPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$H2hPageViewModelCopyWith<_H2hPageViewModel> get copyWith => __$H2hPageViewModelCopyWithImpl<_H2hPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _H2hPageViewModel&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.scopeMode, scopeMode) || other.scopeMode == scopeMode)&&(identical(other.useCurrentSeason, useCurrentSeason) || other.useCurrentSeason == useCurrentSeason)&&(identical(other.currentEntitiesOnly, currentEntitiesOnly) || other.currentEntitiesOnly == currentEntitiesOnly)&&(identical(other.latestSeason, latestSeason) || other.latestSeason == latestSeason)&&(identical(other.seasonSelected, seasonSelected) || other.seasonSelected == seasonSelected)&&(identical(other.driverA, driverA) || other.driverA == driverA)&&(identical(other.driverB, driverB) || other.driverB == driverB)&&(identical(other.constructorA, constructorA) || other.constructorA == constructorA)&&(identical(other.constructorB, constructorB) || other.constructorB == constructorB)&&(identical(other.comparison, comparison) || other.comparison == comparison));
}


@override
int get hashCode => Object.hash(runtimeType,mode,scopeMode,useCurrentSeason,currentEntitiesOnly,latestSeason,seasonSelected,driverA,driverB,constructorA,constructorB,comparison);

@override
String toString() {
  return 'H2hPageViewModel(mode: $mode, scopeMode: $scopeMode, useCurrentSeason: $useCurrentSeason, currentEntitiesOnly: $currentEntitiesOnly, latestSeason: $latestSeason, seasonSelected: $seasonSelected, driverA: $driverA, driverB: $driverB, constructorA: $constructorA, constructorB: $constructorB, comparison: $comparison)';
}


}

/// @nodoc
abstract mixin class _$H2hPageViewModelCopyWith<$Res> implements $H2hPageViewModelCopyWith<$Res> {
  factory _$H2hPageViewModelCopyWith(_H2hPageViewModel value, $Res Function(_H2hPageViewModel) _then) = __$H2hPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 H2hMode mode, int scopeMode, bool useCurrentSeason, bool currentEntitiesOnly, String latestSeason, bool seasonSelected, DriverModel? driverA, DriverModel? driverB, ConstructorModel? constructorA, ConstructorModel? constructorB, Loadable<H2hCompareResult?> comparison
});




}
/// @nodoc
class __$H2hPageViewModelCopyWithImpl<$Res>
    implements _$H2hPageViewModelCopyWith<$Res> {
  __$H2hPageViewModelCopyWithImpl(this._self, this._then);

  final _H2hPageViewModel _self;
  final $Res Function(_H2hPageViewModel) _then;

/// Create a copy of H2hPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? scopeMode = null,Object? useCurrentSeason = null,Object? currentEntitiesOnly = null,Object? latestSeason = null,Object? seasonSelected = null,Object? driverA = freezed,Object? driverB = freezed,Object? constructorA = freezed,Object? constructorB = freezed,Object? comparison = null,}) {
  return _then(_H2hPageViewModel(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as H2hMode,scopeMode: null == scopeMode ? _self.scopeMode : scopeMode // ignore: cast_nullable_to_non_nullable
as int,useCurrentSeason: null == useCurrentSeason ? _self.useCurrentSeason : useCurrentSeason // ignore: cast_nullable_to_non_nullable
as bool,currentEntitiesOnly: null == currentEntitiesOnly ? _self.currentEntitiesOnly : currentEntitiesOnly // ignore: cast_nullable_to_non_nullable
as bool,latestSeason: null == latestSeason ? _self.latestSeason : latestSeason // ignore: cast_nullable_to_non_nullable
as String,seasonSelected: null == seasonSelected ? _self.seasonSelected : seasonSelected // ignore: cast_nullable_to_non_nullable
as bool,driverA: freezed == driverA ? _self.driverA : driverA // ignore: cast_nullable_to_non_nullable
as DriverModel?,driverB: freezed == driverB ? _self.driverB : driverB // ignore: cast_nullable_to_non_nullable
as DriverModel?,constructorA: freezed == constructorA ? _self.constructorA : constructorA // ignore: cast_nullable_to_non_nullable
as ConstructorModel?,constructorB: freezed == constructorB ? _self.constructorB : constructorB // ignore: cast_nullable_to_non_nullable
as ConstructorModel?,comparison: null == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as Loadable<H2hCompareResult?>,
  ));
}


}

// dart format on
