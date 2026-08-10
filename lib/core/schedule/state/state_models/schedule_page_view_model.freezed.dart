// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SchedulePageViewModel implements DiagnosticableTreeMixin {

 DateTime get now; DateTime get selectedDate; DateTime get focusedDate; Loadable<List<RacesModel>> get racesElements; bool get allDataIsLoaded; ScheduleSelectedDay get selectedDay; bool get showingCachedData;
/// Create a copy of SchedulePageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePageViewModelCopyWith<SchedulePageViewModel> get copyWith => _$SchedulePageViewModelCopyWithImpl<SchedulePageViewModel>(this as SchedulePageViewModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SchedulePageViewModel'))
    ..add(DiagnosticsProperty('now', now))..add(DiagnosticsProperty('selectedDate', selectedDate))..add(DiagnosticsProperty('focusedDate', focusedDate))..add(DiagnosticsProperty('racesElements', racesElements))..add(DiagnosticsProperty('allDataIsLoaded', allDataIsLoaded))..add(DiagnosticsProperty('selectedDay', selectedDay))..add(DiagnosticsProperty('showingCachedData', showingCachedData));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePageViewModel&&(identical(other.now, now) || other.now == now)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.focusedDate, focusedDate) || other.focusedDate == focusedDate)&&(identical(other.racesElements, racesElements) || other.racesElements == racesElements)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,now,selectedDate,focusedDate,racesElements,allDataIsLoaded,selectedDay,showingCachedData);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SchedulePageViewModel(now: $now, selectedDate: $selectedDate, focusedDate: $focusedDate, racesElements: $racesElements, allDataIsLoaded: $allDataIsLoaded, selectedDay: $selectedDay, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class $SchedulePageViewModelCopyWith<$Res>  {
  factory $SchedulePageViewModelCopyWith(SchedulePageViewModel value, $Res Function(SchedulePageViewModel) _then) = _$SchedulePageViewModelCopyWithImpl;
@useResult
$Res call({
 DateTime now, DateTime selectedDate, DateTime focusedDate, Loadable<List<RacesModel>> racesElements, bool allDataIsLoaded, ScheduleSelectedDay selectedDay, bool showingCachedData
});




}
/// @nodoc
class _$SchedulePageViewModelCopyWithImpl<$Res>
    implements $SchedulePageViewModelCopyWith<$Res> {
  _$SchedulePageViewModelCopyWithImpl(this._self, this._then);

  final SchedulePageViewModel _self;
  final $Res Function(SchedulePageViewModel) _then;

/// Create a copy of SchedulePageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? now = null,Object? selectedDate = null,Object? focusedDate = null,Object? racesElements = null,Object? allDataIsLoaded = null,Object? selectedDay = null,Object? showingCachedData = null,}) {
  return _then(_self.copyWith(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,focusedDate: null == focusedDate ? _self.focusedDate : focusedDate // ignore: cast_nullable_to_non_nullable
as DateTime,racesElements: null == racesElements ? _self.racesElements : racesElements // ignore: cast_nullable_to_non_nullable
as Loadable<List<RacesModel>>,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as ScheduleSelectedDay,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePageViewModel].
extension SchedulePageViewModelPatterns on SchedulePageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime now,  DateTime selectedDate,  DateTime focusedDate,  Loadable<List<RacesModel>> racesElements,  bool allDataIsLoaded,  ScheduleSelectedDay selectedDay,  bool showingCachedData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePageViewModel() when $default != null:
return $default(_that.now,_that.selectedDate,_that.focusedDate,_that.racesElements,_that.allDataIsLoaded,_that.selectedDay,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime now,  DateTime selectedDate,  DateTime focusedDate,  Loadable<List<RacesModel>> racesElements,  bool allDataIsLoaded,  ScheduleSelectedDay selectedDay,  bool showingCachedData)  $default,) {final _that = this;
switch (_that) {
case _SchedulePageViewModel():
return $default(_that.now,_that.selectedDate,_that.focusedDate,_that.racesElements,_that.allDataIsLoaded,_that.selectedDay,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime now,  DateTime selectedDate,  DateTime focusedDate,  Loadable<List<RacesModel>> racesElements,  bool allDataIsLoaded,  ScheduleSelectedDay selectedDay,  bool showingCachedData)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePageViewModel() when $default != null:
return $default(_that.now,_that.selectedDate,_that.focusedDate,_that.racesElements,_that.allDataIsLoaded,_that.selectedDay,_that.showingCachedData);case _:
  return null;

}
}

}

/// @nodoc


class _SchedulePageViewModel extends SchedulePageViewModel with DiagnosticableTreeMixin {
  const _SchedulePageViewModel({required this.now, required this.selectedDate, required this.focusedDate, this.racesElements = const Loadable.loading(), this.allDataIsLoaded = false, this.selectedDay = ScheduleSelectedDay.empty, this.showingCachedData = false}): super._();
  

@override final  DateTime now;
@override final  DateTime selectedDate;
@override final  DateTime focusedDate;
@override@JsonKey() final  Loadable<List<RacesModel>> racesElements;
@override@JsonKey() final  bool allDataIsLoaded;
@override@JsonKey() final  ScheduleSelectedDay selectedDay;
@override@JsonKey() final  bool showingCachedData;

/// Create a copy of SchedulePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePageViewModelCopyWith<_SchedulePageViewModel> get copyWith => __$SchedulePageViewModelCopyWithImpl<_SchedulePageViewModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SchedulePageViewModel'))
    ..add(DiagnosticsProperty('now', now))..add(DiagnosticsProperty('selectedDate', selectedDate))..add(DiagnosticsProperty('focusedDate', focusedDate))..add(DiagnosticsProperty('racesElements', racesElements))..add(DiagnosticsProperty('allDataIsLoaded', allDataIsLoaded))..add(DiagnosticsProperty('selectedDay', selectedDay))..add(DiagnosticsProperty('showingCachedData', showingCachedData));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePageViewModel&&(identical(other.now, now) || other.now == now)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.focusedDate, focusedDate) || other.focusedDate == focusedDate)&&(identical(other.racesElements, racesElements) || other.racesElements == racesElements)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,now,selectedDate,focusedDate,racesElements,allDataIsLoaded,selectedDay,showingCachedData);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SchedulePageViewModel(now: $now, selectedDate: $selectedDate, focusedDate: $focusedDate, racesElements: $racesElements, allDataIsLoaded: $allDataIsLoaded, selectedDay: $selectedDay, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class _$SchedulePageViewModelCopyWith<$Res> implements $SchedulePageViewModelCopyWith<$Res> {
  factory _$SchedulePageViewModelCopyWith(_SchedulePageViewModel value, $Res Function(_SchedulePageViewModel) _then) = __$SchedulePageViewModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime now, DateTime selectedDate, DateTime focusedDate, Loadable<List<RacesModel>> racesElements, bool allDataIsLoaded, ScheduleSelectedDay selectedDay, bool showingCachedData
});




}
/// @nodoc
class __$SchedulePageViewModelCopyWithImpl<$Res>
    implements _$SchedulePageViewModelCopyWith<$Res> {
  __$SchedulePageViewModelCopyWithImpl(this._self, this._then);

  final _SchedulePageViewModel _self;
  final $Res Function(_SchedulePageViewModel) _then;

/// Create a copy of SchedulePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? now = null,Object? selectedDate = null,Object? focusedDate = null,Object? racesElements = null,Object? allDataIsLoaded = null,Object? selectedDay = null,Object? showingCachedData = null,}) {
  return _then(_SchedulePageViewModel(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,focusedDate: null == focusedDate ? _self.focusedDate : focusedDate // ignore: cast_nullable_to_non_nullable
as DateTime,racesElements: null == racesElements ? _self.racesElements : racesElements // ignore: cast_nullable_to_non_nullable
as Loadable<List<RacesModel>>,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as ScheduleSelectedDay,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
