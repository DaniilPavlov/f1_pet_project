// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResultsPageViewModel {

/// Последняя завершённая гонка.
 Loadable<RacesModel> get lastRace;/// Показываем кэшированные данные (офлайн).
 bool get showingCachedData;
/// Create a copy of ResultsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultsPageViewModelCopyWith<ResultsPageViewModel> get copyWith => _$ResultsPageViewModelCopyWithImpl<ResultsPageViewModel>(this as ResultsPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultsPageViewModel&&(identical(other.lastRace, lastRace) || other.lastRace == lastRace)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,lastRace,showingCachedData);

@override
String toString() {
  return 'ResultsPageViewModel(lastRace: $lastRace, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class $ResultsPageViewModelCopyWith<$Res>  {
  factory $ResultsPageViewModelCopyWith(ResultsPageViewModel value, $Res Function(ResultsPageViewModel) _then) = _$ResultsPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<RacesModel> lastRace, bool showingCachedData
});




}
/// @nodoc
class _$ResultsPageViewModelCopyWithImpl<$Res>
    implements $ResultsPageViewModelCopyWith<$Res> {
  _$ResultsPageViewModelCopyWithImpl(this._self, this._then);

  final ResultsPageViewModel _self;
  final $Res Function(ResultsPageViewModel) _then;

/// Create a copy of ResultsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastRace = null,Object? showingCachedData = null,}) {
  return _then(_self.copyWith(
lastRace: null == lastRace ? _self.lastRace : lastRace // ignore: cast_nullable_to_non_nullable
as Loadable<RacesModel>,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ResultsPageViewModel].
extension ResultsPageViewModelPatterns on ResultsPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultsPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultsPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultsPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _ResultsPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultsPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResultsPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<RacesModel> lastRace,  bool showingCachedData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultsPageViewModel() when $default != null:
return $default(_that.lastRace,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<RacesModel> lastRace,  bool showingCachedData)  $default,) {final _that = this;
switch (_that) {
case _ResultsPageViewModel():
return $default(_that.lastRace,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<RacesModel> lastRace,  bool showingCachedData)?  $default,) {final _that = this;
switch (_that) {
case _ResultsPageViewModel() when $default != null:
return $default(_that.lastRace,_that.showingCachedData);case _:
  return null;

}
}

}

/// @nodoc


class _ResultsPageViewModel extends ResultsPageViewModel {
  const _ResultsPageViewModel({this.lastRace = const Loadable.loading(), this.showingCachedData = false}): super._();
  

/// Последняя завершённая гонка.
@override@JsonKey() final  Loadable<RacesModel> lastRace;
/// Показываем кэшированные данные (офлайн).
@override@JsonKey() final  bool showingCachedData;

/// Create a copy of ResultsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultsPageViewModelCopyWith<_ResultsPageViewModel> get copyWith => __$ResultsPageViewModelCopyWithImpl<_ResultsPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultsPageViewModel&&(identical(other.lastRace, lastRace) || other.lastRace == lastRace)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,lastRace,showingCachedData);

@override
String toString() {
  return 'ResultsPageViewModel(lastRace: $lastRace, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class _$ResultsPageViewModelCopyWith<$Res> implements $ResultsPageViewModelCopyWith<$Res> {
  factory _$ResultsPageViewModelCopyWith(_ResultsPageViewModel value, $Res Function(_ResultsPageViewModel) _then) = __$ResultsPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<RacesModel> lastRace, bool showingCachedData
});




}
/// @nodoc
class __$ResultsPageViewModelCopyWithImpl<$Res>
    implements _$ResultsPageViewModelCopyWith<$Res> {
  __$ResultsPageViewModelCopyWithImpl(this._self, this._then);

  final _ResultsPageViewModel _self;
  final $Res Function(_ResultsPageViewModel) _then;

/// Create a copy of ResultsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastRace = null,Object? showingCachedData = null,}) {
  return _then(_ResultsPageViewModel(
lastRace: null == lastRace ? _self.lastRace : lastRace // ignore: cast_nullable_to_non_nullable
as Loadable<RacesModel>,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
