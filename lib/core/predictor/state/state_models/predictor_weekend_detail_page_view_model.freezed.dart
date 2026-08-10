// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predictor_weekend_detail_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PredictorWeekendDetailPageViewModel {

/// Сравнение предикта квалификации с фактом.
 Loadable<PredictorSessionCompare> get qualifyingCompare;/// Сравнение предикта гонки с фактом.
 Loadable<PredictorSessionCompare> get raceCompare;/// Пилоты по ID (для подписей).
 Map<String, DriverModel> get driversById;/// Выбранная сессия для отображения.
 PredictorDetailSession get selectedSession;/// Все данные загружены.
 bool get allDataIsLoaded;
/// Create a copy of PredictorWeekendDetailPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictorWeekendDetailPageViewModelCopyWith<PredictorWeekendDetailPageViewModel> get copyWith => _$PredictorWeekendDetailPageViewModelCopyWithImpl<PredictorWeekendDetailPageViewModel>(this as PredictorWeekendDetailPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictorWeekendDetailPageViewModel&&(identical(other.qualifyingCompare, qualifyingCompare) || other.qualifyingCompare == qualifyingCompare)&&(identical(other.raceCompare, raceCompare) || other.raceCompare == raceCompare)&&const DeepCollectionEquality().equals(other.driversById, driversById)&&(identical(other.selectedSession, selectedSession) || other.selectedSession == selectedSession)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,qualifyingCompare,raceCompare,const DeepCollectionEquality().hash(driversById),selectedSession,allDataIsLoaded);

@override
String toString() {
  return 'PredictorWeekendDetailPageViewModel(qualifyingCompare: $qualifyingCompare, raceCompare: $raceCompare, driversById: $driversById, selectedSession: $selectedSession, allDataIsLoaded: $allDataIsLoaded)';
}


}

/// @nodoc
abstract mixin class $PredictorWeekendDetailPageViewModelCopyWith<$Res>  {
  factory $PredictorWeekendDetailPageViewModelCopyWith(PredictorWeekendDetailPageViewModel value, $Res Function(PredictorWeekendDetailPageViewModel) _then) = _$PredictorWeekendDetailPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<PredictorSessionCompare> qualifyingCompare, Loadable<PredictorSessionCompare> raceCompare, Map<String, DriverModel> driversById, PredictorDetailSession selectedSession, bool allDataIsLoaded
});




}
/// @nodoc
class _$PredictorWeekendDetailPageViewModelCopyWithImpl<$Res>
    implements $PredictorWeekendDetailPageViewModelCopyWith<$Res> {
  _$PredictorWeekendDetailPageViewModelCopyWithImpl(this._self, this._then);

  final PredictorWeekendDetailPageViewModel _self;
  final $Res Function(PredictorWeekendDetailPageViewModel) _then;

/// Create a copy of PredictorWeekendDetailPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qualifyingCompare = null,Object? raceCompare = null,Object? driversById = null,Object? selectedSession = null,Object? allDataIsLoaded = null,}) {
  return _then(_self.copyWith(
qualifyingCompare: null == qualifyingCompare ? _self.qualifyingCompare : qualifyingCompare // ignore: cast_nullable_to_non_nullable
as Loadable<PredictorSessionCompare>,raceCompare: null == raceCompare ? _self.raceCompare : raceCompare // ignore: cast_nullable_to_non_nullable
as Loadable<PredictorSessionCompare>,driversById: null == driversById ? _self.driversById : driversById // ignore: cast_nullable_to_non_nullable
as Map<String, DriverModel>,selectedSession: null == selectedSession ? _self.selectedSession : selectedSession // ignore: cast_nullable_to_non_nullable
as PredictorDetailSession,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictorWeekendDetailPageViewModel].
extension PredictorWeekendDetailPageViewModelPatterns on PredictorWeekendDetailPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictorWeekendDetailPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictorWeekendDetailPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictorWeekendDetailPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _PredictorWeekendDetailPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictorWeekendDetailPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _PredictorWeekendDetailPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<PredictorSessionCompare> qualifyingCompare,  Loadable<PredictorSessionCompare> raceCompare,  Map<String, DriverModel> driversById,  PredictorDetailSession selectedSession,  bool allDataIsLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictorWeekendDetailPageViewModel() when $default != null:
return $default(_that.qualifyingCompare,_that.raceCompare,_that.driversById,_that.selectedSession,_that.allDataIsLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<PredictorSessionCompare> qualifyingCompare,  Loadable<PredictorSessionCompare> raceCompare,  Map<String, DriverModel> driversById,  PredictorDetailSession selectedSession,  bool allDataIsLoaded)  $default,) {final _that = this;
switch (_that) {
case _PredictorWeekendDetailPageViewModel():
return $default(_that.qualifyingCompare,_that.raceCompare,_that.driversById,_that.selectedSession,_that.allDataIsLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<PredictorSessionCompare> qualifyingCompare,  Loadable<PredictorSessionCompare> raceCompare,  Map<String, DriverModel> driversById,  PredictorDetailSession selectedSession,  bool allDataIsLoaded)?  $default,) {final _that = this;
switch (_that) {
case _PredictorWeekendDetailPageViewModel() when $default != null:
return $default(_that.qualifyingCompare,_that.raceCompare,_that.driversById,_that.selectedSession,_that.allDataIsLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _PredictorWeekendDetailPageViewModel extends PredictorWeekendDetailPageViewModel {
  const _PredictorWeekendDetailPageViewModel({this.qualifyingCompare = const Loadable.loading(), this.raceCompare = const Loadable.loading(), final  Map<String, DriverModel> driversById = const <String, DriverModel>{}, this.selectedSession = PredictorDetailSession.qualifying, this.allDataIsLoaded = false}): _driversById = driversById,super._();
  

/// Сравнение предикта квалификации с фактом.
@override@JsonKey() final  Loadable<PredictorSessionCompare> qualifyingCompare;
/// Сравнение предикта гонки с фактом.
@override@JsonKey() final  Loadable<PredictorSessionCompare> raceCompare;
/// Пилоты по ID (для подписей).
 final  Map<String, DriverModel> _driversById;
/// Пилоты по ID (для подписей).
@override@JsonKey() Map<String, DriverModel> get driversById {
  if (_driversById is EqualUnmodifiableMapView) return _driversById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_driversById);
}

/// Выбранная сессия для отображения.
@override@JsonKey() final  PredictorDetailSession selectedSession;
/// Все данные загружены.
@override@JsonKey() final  bool allDataIsLoaded;

/// Create a copy of PredictorWeekendDetailPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictorWeekendDetailPageViewModelCopyWith<_PredictorWeekendDetailPageViewModel> get copyWith => __$PredictorWeekendDetailPageViewModelCopyWithImpl<_PredictorWeekendDetailPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictorWeekendDetailPageViewModel&&(identical(other.qualifyingCompare, qualifyingCompare) || other.qualifyingCompare == qualifyingCompare)&&(identical(other.raceCompare, raceCompare) || other.raceCompare == raceCompare)&&const DeepCollectionEquality().equals(other._driversById, _driversById)&&(identical(other.selectedSession, selectedSession) || other.selectedSession == selectedSession)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,qualifyingCompare,raceCompare,const DeepCollectionEquality().hash(_driversById),selectedSession,allDataIsLoaded);

@override
String toString() {
  return 'PredictorWeekendDetailPageViewModel(qualifyingCompare: $qualifyingCompare, raceCompare: $raceCompare, driversById: $driversById, selectedSession: $selectedSession, allDataIsLoaded: $allDataIsLoaded)';
}


}

/// @nodoc
abstract mixin class _$PredictorWeekendDetailPageViewModelCopyWith<$Res> implements $PredictorWeekendDetailPageViewModelCopyWith<$Res> {
  factory _$PredictorWeekendDetailPageViewModelCopyWith(_PredictorWeekendDetailPageViewModel value, $Res Function(_PredictorWeekendDetailPageViewModel) _then) = __$PredictorWeekendDetailPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<PredictorSessionCompare> qualifyingCompare, Loadable<PredictorSessionCompare> raceCompare, Map<String, DriverModel> driversById, PredictorDetailSession selectedSession, bool allDataIsLoaded
});




}
/// @nodoc
class __$PredictorWeekendDetailPageViewModelCopyWithImpl<$Res>
    implements _$PredictorWeekendDetailPageViewModelCopyWith<$Res> {
  __$PredictorWeekendDetailPageViewModelCopyWithImpl(this._self, this._then);

  final _PredictorWeekendDetailPageViewModel _self;
  final $Res Function(_PredictorWeekendDetailPageViewModel) _then;

/// Create a copy of PredictorWeekendDetailPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qualifyingCompare = null,Object? raceCompare = null,Object? driversById = null,Object? selectedSession = null,Object? allDataIsLoaded = null,}) {
  return _then(_PredictorWeekendDetailPageViewModel(
qualifyingCompare: null == qualifyingCompare ? _self.qualifyingCompare : qualifyingCompare // ignore: cast_nullable_to_non_nullable
as Loadable<PredictorSessionCompare>,raceCompare: null == raceCompare ? _self.raceCompare : raceCompare // ignore: cast_nullable_to_non_nullable
as Loadable<PredictorSessionCompare>,driversById: null == driversById ? _self._driversById : driversById // ignore: cast_nullable_to_non_nullable
as Map<String, DriverModel>,selectedSession: null == selectedSession ? _self.selectedSession : selectedSession // ignore: cast_nullable_to_non_nullable
as PredictorDetailSession,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
