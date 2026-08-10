// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'constructor_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConstructorPageViewModel {

 Loadable<CareerStats<DriverModel>> get careerStats; Loadable<List<NewsArticleModel>> get espnNews;
/// Create a copy of ConstructorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConstructorPageViewModelCopyWith<ConstructorPageViewModel> get copyWith => _$ConstructorPageViewModelCopyWithImpl<ConstructorPageViewModel>(this as ConstructorPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConstructorPageViewModel&&(identical(other.careerStats, careerStats) || other.careerStats == careerStats)&&(identical(other.espnNews, espnNews) || other.espnNews == espnNews));
}


@override
int get hashCode => Object.hash(runtimeType,careerStats,espnNews);

@override
String toString() {
  return 'ConstructorPageViewModel(careerStats: $careerStats, espnNews: $espnNews)';
}


}

/// @nodoc
abstract mixin class $ConstructorPageViewModelCopyWith<$Res>  {
  factory $ConstructorPageViewModelCopyWith(ConstructorPageViewModel value, $Res Function(ConstructorPageViewModel) _then) = _$ConstructorPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<CareerStats<DriverModel>> careerStats, Loadable<List<NewsArticleModel>> espnNews
});




}
/// @nodoc
class _$ConstructorPageViewModelCopyWithImpl<$Res>
    implements $ConstructorPageViewModelCopyWith<$Res> {
  _$ConstructorPageViewModelCopyWithImpl(this._self, this._then);

  final ConstructorPageViewModel _self;
  final $Res Function(ConstructorPageViewModel) _then;

/// Create a copy of ConstructorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? careerStats = null,Object? espnNews = null,}) {
  return _then(_self.copyWith(
careerStats: null == careerStats ? _self.careerStats : careerStats // ignore: cast_nullable_to_non_nullable
as Loadable<CareerStats<DriverModel>>,espnNews: null == espnNews ? _self.espnNews : espnNews // ignore: cast_nullable_to_non_nullable
as Loadable<List<NewsArticleModel>>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConstructorPageViewModel].
extension ConstructorPageViewModelPatterns on ConstructorPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConstructorPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConstructorPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConstructorPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _ConstructorPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConstructorPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConstructorPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<CareerStats<DriverModel>> careerStats,  Loadable<List<NewsArticleModel>> espnNews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConstructorPageViewModel() when $default != null:
return $default(_that.careerStats,_that.espnNews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<CareerStats<DriverModel>> careerStats,  Loadable<List<NewsArticleModel>> espnNews)  $default,) {final _that = this;
switch (_that) {
case _ConstructorPageViewModel():
return $default(_that.careerStats,_that.espnNews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<CareerStats<DriverModel>> careerStats,  Loadable<List<NewsArticleModel>> espnNews)?  $default,) {final _that = this;
switch (_that) {
case _ConstructorPageViewModel() when $default != null:
return $default(_that.careerStats,_that.espnNews);case _:
  return null;

}
}

}

/// @nodoc


class _ConstructorPageViewModel extends ConstructorPageViewModel {
  const _ConstructorPageViewModel({this.careerStats = const Loadable.loading(), this.espnNews = const Loadable.loading()}): super._();
  

@override@JsonKey() final  Loadable<CareerStats<DriverModel>> careerStats;
@override@JsonKey() final  Loadable<List<NewsArticleModel>> espnNews;

/// Create a copy of ConstructorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConstructorPageViewModelCopyWith<_ConstructorPageViewModel> get copyWith => __$ConstructorPageViewModelCopyWithImpl<_ConstructorPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConstructorPageViewModel&&(identical(other.careerStats, careerStats) || other.careerStats == careerStats)&&(identical(other.espnNews, espnNews) || other.espnNews == espnNews));
}


@override
int get hashCode => Object.hash(runtimeType,careerStats,espnNews);

@override
String toString() {
  return 'ConstructorPageViewModel(careerStats: $careerStats, espnNews: $espnNews)';
}


}

/// @nodoc
abstract mixin class _$ConstructorPageViewModelCopyWith<$Res> implements $ConstructorPageViewModelCopyWith<$Res> {
  factory _$ConstructorPageViewModelCopyWith(_ConstructorPageViewModel value, $Res Function(_ConstructorPageViewModel) _then) = __$ConstructorPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<CareerStats<DriverModel>> careerStats, Loadable<List<NewsArticleModel>> espnNews
});




}
/// @nodoc
class __$ConstructorPageViewModelCopyWithImpl<$Res>
    implements _$ConstructorPageViewModelCopyWith<$Res> {
  __$ConstructorPageViewModelCopyWithImpl(this._self, this._then);

  final _ConstructorPageViewModel _self;
  final $Res Function(_ConstructorPageViewModel) _then;

/// Create a copy of ConstructorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? careerStats = null,Object? espnNews = null,}) {
  return _then(_ConstructorPageViewModel(
careerStats: null == careerStats ? _self.careerStats : careerStats // ignore: cast_nullable_to_non_nullable
as Loadable<CareerStats<DriverModel>>,espnNews: null == espnNews ? _self.espnNews : espnNews // ignore: cast_nullable_to_non_nullable
as Loadable<List<NewsArticleModel>>,
  ));
}


}

// dart format on
