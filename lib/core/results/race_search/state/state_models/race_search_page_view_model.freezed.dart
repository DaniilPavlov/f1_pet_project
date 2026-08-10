// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'race_search_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RaceSearchPageViewModel {

/// Найденная гонка.
 Loadable<RacesModel?> get searchedRace;/// Данные полностью загружены.
 bool get dataIsLoaded;/// Сезон и раунд заполнены.
 bool get fieldsInputted;/// Сообщение об ошибке.
 String get errorMessage;/// Выбранный сезон.
 String get selectedSeason;
/// Create a copy of RaceSearchPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RaceSearchPageViewModelCopyWith<RaceSearchPageViewModel> get copyWith => _$RaceSearchPageViewModelCopyWithImpl<RaceSearchPageViewModel>(this as RaceSearchPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RaceSearchPageViewModel&&(identical(other.searchedRace, searchedRace) || other.searchedRace == searchedRace)&&(identical(other.dataIsLoaded, dataIsLoaded) || other.dataIsLoaded == dataIsLoaded)&&(identical(other.fieldsInputted, fieldsInputted) || other.fieldsInputted == fieldsInputted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.selectedSeason, selectedSeason) || other.selectedSeason == selectedSeason));
}


@override
int get hashCode => Object.hash(runtimeType,searchedRace,dataIsLoaded,fieldsInputted,errorMessage,selectedSeason);

@override
String toString() {
  return 'RaceSearchPageViewModel(searchedRace: $searchedRace, dataIsLoaded: $dataIsLoaded, fieldsInputted: $fieldsInputted, errorMessage: $errorMessage, selectedSeason: $selectedSeason)';
}


}

/// @nodoc
abstract mixin class $RaceSearchPageViewModelCopyWith<$Res>  {
  factory $RaceSearchPageViewModelCopyWith(RaceSearchPageViewModel value, $Res Function(RaceSearchPageViewModel) _then) = _$RaceSearchPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<RacesModel?> searchedRace, bool dataIsLoaded, bool fieldsInputted, String errorMessage, String selectedSeason
});




}
/// @nodoc
class _$RaceSearchPageViewModelCopyWithImpl<$Res>
    implements $RaceSearchPageViewModelCopyWith<$Res> {
  _$RaceSearchPageViewModelCopyWithImpl(this._self, this._then);

  final RaceSearchPageViewModel _self;
  final $Res Function(RaceSearchPageViewModel) _then;

/// Create a copy of RaceSearchPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchedRace = null,Object? dataIsLoaded = null,Object? fieldsInputted = null,Object? errorMessage = null,Object? selectedSeason = null,}) {
  return _then(_self.copyWith(
searchedRace: null == searchedRace ? _self.searchedRace : searchedRace // ignore: cast_nullable_to_non_nullable
as Loadable<RacesModel?>,dataIsLoaded: null == dataIsLoaded ? _self.dataIsLoaded : dataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,fieldsInputted: null == fieldsInputted ? _self.fieldsInputted : fieldsInputted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,selectedSeason: null == selectedSeason ? _self.selectedSeason : selectedSeason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RaceSearchPageViewModel].
extension RaceSearchPageViewModelPatterns on RaceSearchPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RaceSearchPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RaceSearchPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RaceSearchPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _RaceSearchPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RaceSearchPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _RaceSearchPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<RacesModel?> searchedRace,  bool dataIsLoaded,  bool fieldsInputted,  String errorMessage,  String selectedSeason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RaceSearchPageViewModel() when $default != null:
return $default(_that.searchedRace,_that.dataIsLoaded,_that.fieldsInputted,_that.errorMessage,_that.selectedSeason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<RacesModel?> searchedRace,  bool dataIsLoaded,  bool fieldsInputted,  String errorMessage,  String selectedSeason)  $default,) {final _that = this;
switch (_that) {
case _RaceSearchPageViewModel():
return $default(_that.searchedRace,_that.dataIsLoaded,_that.fieldsInputted,_that.errorMessage,_that.selectedSeason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<RacesModel?> searchedRace,  bool dataIsLoaded,  bool fieldsInputted,  String errorMessage,  String selectedSeason)?  $default,) {final _that = this;
switch (_that) {
case _RaceSearchPageViewModel() when $default != null:
return $default(_that.searchedRace,_that.dataIsLoaded,_that.fieldsInputted,_that.errorMessage,_that.selectedSeason);case _:
  return null;

}
}

}

/// @nodoc


class _RaceSearchPageViewModel implements RaceSearchPageViewModel {
  const _RaceSearchPageViewModel({this.searchedRace = const Loadable.value(), this.dataIsLoaded = true, this.fieldsInputted = false, this.errorMessage = '', this.selectedSeason = ''});
  

/// Найденная гонка.
@override@JsonKey() final  Loadable<RacesModel?> searchedRace;
/// Данные полностью загружены.
@override@JsonKey() final  bool dataIsLoaded;
/// Сезон и раунд заполнены.
@override@JsonKey() final  bool fieldsInputted;
/// Сообщение об ошибке.
@override@JsonKey() final  String errorMessage;
/// Выбранный сезон.
@override@JsonKey() final  String selectedSeason;

/// Create a copy of RaceSearchPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RaceSearchPageViewModelCopyWith<_RaceSearchPageViewModel> get copyWith => __$RaceSearchPageViewModelCopyWithImpl<_RaceSearchPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RaceSearchPageViewModel&&(identical(other.searchedRace, searchedRace) || other.searchedRace == searchedRace)&&(identical(other.dataIsLoaded, dataIsLoaded) || other.dataIsLoaded == dataIsLoaded)&&(identical(other.fieldsInputted, fieldsInputted) || other.fieldsInputted == fieldsInputted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.selectedSeason, selectedSeason) || other.selectedSeason == selectedSeason));
}


@override
int get hashCode => Object.hash(runtimeType,searchedRace,dataIsLoaded,fieldsInputted,errorMessage,selectedSeason);

@override
String toString() {
  return 'RaceSearchPageViewModel(searchedRace: $searchedRace, dataIsLoaded: $dataIsLoaded, fieldsInputted: $fieldsInputted, errorMessage: $errorMessage, selectedSeason: $selectedSeason)';
}


}

/// @nodoc
abstract mixin class _$RaceSearchPageViewModelCopyWith<$Res> implements $RaceSearchPageViewModelCopyWith<$Res> {
  factory _$RaceSearchPageViewModelCopyWith(_RaceSearchPageViewModel value, $Res Function(_RaceSearchPageViewModel) _then) = __$RaceSearchPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<RacesModel?> searchedRace, bool dataIsLoaded, bool fieldsInputted, String errorMessage, String selectedSeason
});




}
/// @nodoc
class __$RaceSearchPageViewModelCopyWithImpl<$Res>
    implements _$RaceSearchPageViewModelCopyWith<$Res> {
  __$RaceSearchPageViewModelCopyWithImpl(this._self, this._then);

  final _RaceSearchPageViewModel _self;
  final $Res Function(_RaceSearchPageViewModel) _then;

/// Create a copy of RaceSearchPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchedRace = null,Object? dataIsLoaded = null,Object? fieldsInputted = null,Object? errorMessage = null,Object? selectedSeason = null,}) {
  return _then(_RaceSearchPageViewModel(
searchedRace: null == searchedRace ? _self.searchedRace : searchedRace // ignore: cast_nullable_to_non_nullable
as Loadable<RacesModel?>,dataIsLoaded: null == dataIsLoaded ? _self.dataIsLoaded : dataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,fieldsInputted: null == fieldsInputted ? _self.fieldsInputted : fieldsInputted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,selectedSeason: null == selectedSeason ? _self.selectedSeason : selectedSeason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
