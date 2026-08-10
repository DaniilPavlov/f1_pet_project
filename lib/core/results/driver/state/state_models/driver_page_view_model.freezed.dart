// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DriverPageViewModel {

/// Карьерная статистика (тоталы и список гонок).
 Loadable<CareerStats<ConstructorModel>> get careerStats;/// Данные из ESPN (фото, флаг, новости).
 Loadable<EspnDriverCardData> get espnCard;
/// Create a copy of DriverPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverPageViewModelCopyWith<DriverPageViewModel> get copyWith => _$DriverPageViewModelCopyWithImpl<DriverPageViewModel>(this as DriverPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverPageViewModel&&(identical(other.careerStats, careerStats) || other.careerStats == careerStats)&&(identical(other.espnCard, espnCard) || other.espnCard == espnCard));
}


@override
int get hashCode => Object.hash(runtimeType,careerStats,espnCard);

@override
String toString() {
  return 'DriverPageViewModel(careerStats: $careerStats, espnCard: $espnCard)';
}


}

/// @nodoc
abstract mixin class $DriverPageViewModelCopyWith<$Res>  {
  factory $DriverPageViewModelCopyWith(DriverPageViewModel value, $Res Function(DriverPageViewModel) _then) = _$DriverPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<CareerStats<ConstructorModel>> careerStats, Loadable<EspnDriverCardData> espnCard
});




}
/// @nodoc
class _$DriverPageViewModelCopyWithImpl<$Res>
    implements $DriverPageViewModelCopyWith<$Res> {
  _$DriverPageViewModelCopyWithImpl(this._self, this._then);

  final DriverPageViewModel _self;
  final $Res Function(DriverPageViewModel) _then;

/// Create a copy of DriverPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? careerStats = null,Object? espnCard = null,}) {
  return _then(_self.copyWith(
careerStats: null == careerStats ? _self.careerStats : careerStats // ignore: cast_nullable_to_non_nullable
as Loadable<CareerStats<ConstructorModel>>,espnCard: null == espnCard ? _self.espnCard : espnCard // ignore: cast_nullable_to_non_nullable
as Loadable<EspnDriverCardData>,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverPageViewModel].
extension DriverPageViewModelPatterns on DriverPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _DriverPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriverPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<CareerStats<ConstructorModel>> careerStats,  Loadable<EspnDriverCardData> espnCard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverPageViewModel() when $default != null:
return $default(_that.careerStats,_that.espnCard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<CareerStats<ConstructorModel>> careerStats,  Loadable<EspnDriverCardData> espnCard)  $default,) {final _that = this;
switch (_that) {
case _DriverPageViewModel():
return $default(_that.careerStats,_that.espnCard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<CareerStats<ConstructorModel>> careerStats,  Loadable<EspnDriverCardData> espnCard)?  $default,) {final _that = this;
switch (_that) {
case _DriverPageViewModel() when $default != null:
return $default(_that.careerStats,_that.espnCard);case _:
  return null;

}
}

}

/// @nodoc


class _DriverPageViewModel extends DriverPageViewModel {
  const _DriverPageViewModel({this.careerStats = const Loadable.loading(), this.espnCard = const Loadable.loading()}): super._();
  

/// Карьерная статистика (тоталы и список гонок).
@override@JsonKey() final  Loadable<CareerStats<ConstructorModel>> careerStats;
/// Данные из ESPN (фото, флаг, новости).
@override@JsonKey() final  Loadable<EspnDriverCardData> espnCard;

/// Create a copy of DriverPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverPageViewModelCopyWith<_DriverPageViewModel> get copyWith => __$DriverPageViewModelCopyWithImpl<_DriverPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverPageViewModel&&(identical(other.careerStats, careerStats) || other.careerStats == careerStats)&&(identical(other.espnCard, espnCard) || other.espnCard == espnCard));
}


@override
int get hashCode => Object.hash(runtimeType,careerStats,espnCard);

@override
String toString() {
  return 'DriverPageViewModel(careerStats: $careerStats, espnCard: $espnCard)';
}


}

/// @nodoc
abstract mixin class _$DriverPageViewModelCopyWith<$Res> implements $DriverPageViewModelCopyWith<$Res> {
  factory _$DriverPageViewModelCopyWith(_DriverPageViewModel value, $Res Function(_DriverPageViewModel) _then) = __$DriverPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<CareerStats<ConstructorModel>> careerStats, Loadable<EspnDriverCardData> espnCard
});




}
/// @nodoc
class __$DriverPageViewModelCopyWithImpl<$Res>
    implements _$DriverPageViewModelCopyWith<$Res> {
  __$DriverPageViewModelCopyWithImpl(this._self, this._then);

  final _DriverPageViewModel _self;
  final $Res Function(_DriverPageViewModel) _then;

/// Create a copy of DriverPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? careerStats = null,Object? espnCard = null,}) {
  return _then(_DriverPageViewModel(
careerStats: null == careerStats ? _self.careerStats : careerStats // ignore: cast_nullable_to_non_nullable
as Loadable<CareerStats<ConstructorModel>>,espnCard: null == espnCard ? _self.espnCard : espnCard // ignore: cast_nullable_to_non_nullable
as Loadable<EspnDriverCardData>,
  ));
}


}

// dart format on
