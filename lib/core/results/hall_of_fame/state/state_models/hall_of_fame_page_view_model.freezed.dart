// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hall_of_fame_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HallOfFamePageViewModel {

/// Зачёт пилотов.
 Loadable<List<StandingsListsModel>> get driversStandings;/// Зачёт конструкторов.
 Loadable<List<StandingsListsModel>> get constructorsStandings;/// Год заполнен и валиден.
 bool get fieldsInputted;
/// Create a copy of HallOfFamePageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallOfFamePageViewModelCopyWith<HallOfFamePageViewModel> get copyWith => _$HallOfFamePageViewModelCopyWithImpl<HallOfFamePageViewModel>(this as HallOfFamePageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallOfFamePageViewModel&&(identical(other.driversStandings, driversStandings) || other.driversStandings == driversStandings)&&(identical(other.constructorsStandings, constructorsStandings) || other.constructorsStandings == constructorsStandings)&&(identical(other.fieldsInputted, fieldsInputted) || other.fieldsInputted == fieldsInputted));
}


@override
int get hashCode => Object.hash(runtimeType,driversStandings,constructorsStandings,fieldsInputted);

@override
String toString() {
  return 'HallOfFamePageViewModel(driversStandings: $driversStandings, constructorsStandings: $constructorsStandings, fieldsInputted: $fieldsInputted)';
}


}

/// @nodoc
abstract mixin class $HallOfFamePageViewModelCopyWith<$Res>  {
  factory $HallOfFamePageViewModelCopyWith(HallOfFamePageViewModel value, $Res Function(HallOfFamePageViewModel) _then) = _$HallOfFamePageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<List<StandingsListsModel>> driversStandings, Loadable<List<StandingsListsModel>> constructorsStandings, bool fieldsInputted
});




}
/// @nodoc
class _$HallOfFamePageViewModelCopyWithImpl<$Res>
    implements $HallOfFamePageViewModelCopyWith<$Res> {
  _$HallOfFamePageViewModelCopyWithImpl(this._self, this._then);

  final HallOfFamePageViewModel _self;
  final $Res Function(HallOfFamePageViewModel) _then;

/// Create a copy of HallOfFamePageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? driversStandings = null,Object? constructorsStandings = null,Object? fieldsInputted = null,}) {
  return _then(_self.copyWith(
driversStandings: null == driversStandings ? _self.driversStandings : driversStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,constructorsStandings: null == constructorsStandings ? _self.constructorsStandings : constructorsStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,fieldsInputted: null == fieldsInputted ? _self.fieldsInputted : fieldsInputted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HallOfFamePageViewModel].
extension HallOfFamePageViewModelPatterns on HallOfFamePageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallOfFamePageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallOfFamePageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallOfFamePageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _HallOfFamePageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallOfFamePageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _HallOfFamePageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<List<StandingsListsModel>> driversStandings,  Loadable<List<StandingsListsModel>> constructorsStandings,  bool fieldsInputted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallOfFamePageViewModel() when $default != null:
return $default(_that.driversStandings,_that.constructorsStandings,_that.fieldsInputted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<List<StandingsListsModel>> driversStandings,  Loadable<List<StandingsListsModel>> constructorsStandings,  bool fieldsInputted)  $default,) {final _that = this;
switch (_that) {
case _HallOfFamePageViewModel():
return $default(_that.driversStandings,_that.constructorsStandings,_that.fieldsInputted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<List<StandingsListsModel>> driversStandings,  Loadable<List<StandingsListsModel>> constructorsStandings,  bool fieldsInputted)?  $default,) {final _that = this;
switch (_that) {
case _HallOfFamePageViewModel() when $default != null:
return $default(_that.driversStandings,_that.constructorsStandings,_that.fieldsInputted);case _:
  return null;

}
}

}

/// @nodoc


class _HallOfFamePageViewModel extends HallOfFamePageViewModel {
  const _HallOfFamePageViewModel({this.driversStandings = const Loadable.loading(), this.constructorsStandings = const Loadable.loading(), this.fieldsInputted = true}): super._();
  

/// Зачёт пилотов.
@override@JsonKey() final  Loadable<List<StandingsListsModel>> driversStandings;
/// Зачёт конструкторов.
@override@JsonKey() final  Loadable<List<StandingsListsModel>> constructorsStandings;
/// Год заполнен и валиден.
@override@JsonKey() final  bool fieldsInputted;

/// Create a copy of HallOfFamePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallOfFamePageViewModelCopyWith<_HallOfFamePageViewModel> get copyWith => __$HallOfFamePageViewModelCopyWithImpl<_HallOfFamePageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallOfFamePageViewModel&&(identical(other.driversStandings, driversStandings) || other.driversStandings == driversStandings)&&(identical(other.constructorsStandings, constructorsStandings) || other.constructorsStandings == constructorsStandings)&&(identical(other.fieldsInputted, fieldsInputted) || other.fieldsInputted == fieldsInputted));
}


@override
int get hashCode => Object.hash(runtimeType,driversStandings,constructorsStandings,fieldsInputted);

@override
String toString() {
  return 'HallOfFamePageViewModel(driversStandings: $driversStandings, constructorsStandings: $constructorsStandings, fieldsInputted: $fieldsInputted)';
}


}

/// @nodoc
abstract mixin class _$HallOfFamePageViewModelCopyWith<$Res> implements $HallOfFamePageViewModelCopyWith<$Res> {
  factory _$HallOfFamePageViewModelCopyWith(_HallOfFamePageViewModel value, $Res Function(_HallOfFamePageViewModel) _then) = __$HallOfFamePageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<List<StandingsListsModel>> driversStandings, Loadable<List<StandingsListsModel>> constructorsStandings, bool fieldsInputted
});




}
/// @nodoc
class __$HallOfFamePageViewModelCopyWithImpl<$Res>
    implements _$HallOfFamePageViewModelCopyWith<$Res> {
  __$HallOfFamePageViewModelCopyWithImpl(this._self, this._then);

  final _HallOfFamePageViewModel _self;
  final $Res Function(_HallOfFamePageViewModel) _then;

/// Create a copy of HallOfFamePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? driversStandings = null,Object? constructorsStandings = null,Object? fieldsInputted = null,}) {
  return _then(_HallOfFamePageViewModel(
driversStandings: null == driversStandings ? _self.driversStandings : driversStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,constructorsStandings: null == constructorsStandings ? _self.constructorsStandings : constructorsStandings // ignore: cast_nullable_to_non_nullable
as Loadable<List<StandingsListsModel>>,fieldsInputted: null == fieldsInputted ? _self.fieldsInputted : fieldsInputted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
