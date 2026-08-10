// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circuit_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CircuitPageViewModel {

/// Историческое победители на трассе.
 Loadable<List<CircuitRaceWin>> get winners;/// URL фото трассы (мягкое издаётся на ошибку).
 Loadable<String?> get photoUrl;/// Статистика трассы (мягкое издаётся на ошибку).
 Loadable<CircuitStats?> get stats;
/// Create a copy of CircuitPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitPageViewModelCopyWith<CircuitPageViewModel> get copyWith => _$CircuitPageViewModelCopyWithImpl<CircuitPageViewModel>(this as CircuitPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitPageViewModel&&(identical(other.winners, winners) || other.winners == winners)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.stats, stats) || other.stats == stats));
}


@override
int get hashCode => Object.hash(runtimeType,winners,photoUrl,stats);

@override
String toString() {
  return 'CircuitPageViewModel(winners: $winners, photoUrl: $photoUrl, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $CircuitPageViewModelCopyWith<$Res>  {
  factory $CircuitPageViewModelCopyWith(CircuitPageViewModel value, $Res Function(CircuitPageViewModel) _then) = _$CircuitPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<List<CircuitRaceWin>> winners, Loadable<String?> photoUrl, Loadable<CircuitStats?> stats
});




}
/// @nodoc
class _$CircuitPageViewModelCopyWithImpl<$Res>
    implements $CircuitPageViewModelCopyWith<$Res> {
  _$CircuitPageViewModelCopyWithImpl(this._self, this._then);

  final CircuitPageViewModel _self;
  final $Res Function(CircuitPageViewModel) _then;

/// Create a copy of CircuitPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? winners = null,Object? photoUrl = null,Object? stats = null,}) {
  return _then(_self.copyWith(
winners: null == winners ? _self.winners : winners // ignore: cast_nullable_to_non_nullable
as Loadable<List<CircuitRaceWin>>,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as Loadable<String?>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Loadable<CircuitStats?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CircuitPageViewModel].
extension CircuitPageViewModelPatterns on CircuitPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircuitPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircuitPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircuitPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _CircuitPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircuitPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _CircuitPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<List<CircuitRaceWin>> winners,  Loadable<String?> photoUrl,  Loadable<CircuitStats?> stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircuitPageViewModel() when $default != null:
return $default(_that.winners,_that.photoUrl,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<List<CircuitRaceWin>> winners,  Loadable<String?> photoUrl,  Loadable<CircuitStats?> stats)  $default,) {final _that = this;
switch (_that) {
case _CircuitPageViewModel():
return $default(_that.winners,_that.photoUrl,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<List<CircuitRaceWin>> winners,  Loadable<String?> photoUrl,  Loadable<CircuitStats?> stats)?  $default,) {final _that = this;
switch (_that) {
case _CircuitPageViewModel() when $default != null:
return $default(_that.winners,_that.photoUrl,_that.stats);case _:
  return null;

}
}

}

/// @nodoc


class _CircuitPageViewModel extends CircuitPageViewModel {
  const _CircuitPageViewModel({this.winners = const Loadable.loading(), this.photoUrl = const Loadable.loading(), this.stats = const Loadable.loading()}): super._();
  

/// Историческое победители на трассе.
@override@JsonKey() final  Loadable<List<CircuitRaceWin>> winners;
/// URL фото трассы (мягкое издаётся на ошибку).
@override@JsonKey() final  Loadable<String?> photoUrl;
/// Статистика трассы (мягкое издаётся на ошибку).
@override@JsonKey() final  Loadable<CircuitStats?> stats;

/// Create a copy of CircuitPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircuitPageViewModelCopyWith<_CircuitPageViewModel> get copyWith => __$CircuitPageViewModelCopyWithImpl<_CircuitPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircuitPageViewModel&&(identical(other.winners, winners) || other.winners == winners)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.stats, stats) || other.stats == stats));
}


@override
int get hashCode => Object.hash(runtimeType,winners,photoUrl,stats);

@override
String toString() {
  return 'CircuitPageViewModel(winners: $winners, photoUrl: $photoUrl, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$CircuitPageViewModelCopyWith<$Res> implements $CircuitPageViewModelCopyWith<$Res> {
  factory _$CircuitPageViewModelCopyWith(_CircuitPageViewModel value, $Res Function(_CircuitPageViewModel) _then) = __$CircuitPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<List<CircuitRaceWin>> winners, Loadable<String?> photoUrl, Loadable<CircuitStats?> stats
});




}
/// @nodoc
class __$CircuitPageViewModelCopyWithImpl<$Res>
    implements _$CircuitPageViewModelCopyWith<$Res> {
  __$CircuitPageViewModelCopyWithImpl(this._self, this._then);

  final _CircuitPageViewModel _self;
  final $Res Function(_CircuitPageViewModel) _then;

/// Create a copy of CircuitPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? winners = null,Object? photoUrl = null,Object? stats = null,}) {
  return _then(_CircuitPageViewModel(
winners: null == winners ? _self.winners : winners // ignore: cast_nullable_to_non_nullable
as Loadable<List<CircuitRaceWin>>,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as Loadable<String?>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Loadable<CircuitStats?>,
  ));
}


}

// dart format on
