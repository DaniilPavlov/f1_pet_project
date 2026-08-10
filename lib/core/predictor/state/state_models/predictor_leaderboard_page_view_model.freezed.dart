// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predictor_leaderboard_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PredictorLeaderboardPageViewModel {

/// Мой профиль на лидерборде.
 PredictorLeaderboardProfile get profile;/// Записи лидерборда.
 Loadable<List<PredictorLeaderboardEntry>> get entries;/// Черновик никнейма.
 String get nicknameDraft;/// Согласие на opt-in.
 bool get optInAgreed;/// Идёт сохранение.
 bool get isSaving;/// Ключ ошибки формы (локализация).
 String? get formErrorKey;/// Данные полностью загружены.
 bool get allDataIsLoaded;
/// Create a copy of PredictorLeaderboardPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictorLeaderboardPageViewModelCopyWith<PredictorLeaderboardPageViewModel> get copyWith => _$PredictorLeaderboardPageViewModelCopyWithImpl<PredictorLeaderboardPageViewModel>(this as PredictorLeaderboardPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictorLeaderboardPageViewModel&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.entries, entries) || other.entries == entries)&&(identical(other.nicknameDraft, nicknameDraft) || other.nicknameDraft == nicknameDraft)&&(identical(other.optInAgreed, optInAgreed) || other.optInAgreed == optInAgreed)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.formErrorKey, formErrorKey) || other.formErrorKey == formErrorKey)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,profile,entries,nicknameDraft,optInAgreed,isSaving,formErrorKey,allDataIsLoaded);

@override
String toString() {
  return 'PredictorLeaderboardPageViewModel(profile: $profile, entries: $entries, nicknameDraft: $nicknameDraft, optInAgreed: $optInAgreed, isSaving: $isSaving, formErrorKey: $formErrorKey, allDataIsLoaded: $allDataIsLoaded)';
}


}

/// @nodoc
abstract mixin class $PredictorLeaderboardPageViewModelCopyWith<$Res>  {
  factory $PredictorLeaderboardPageViewModelCopyWith(PredictorLeaderboardPageViewModel value, $Res Function(PredictorLeaderboardPageViewModel) _then) = _$PredictorLeaderboardPageViewModelCopyWithImpl;
@useResult
$Res call({
 PredictorLeaderboardProfile profile, Loadable<List<PredictorLeaderboardEntry>> entries, String nicknameDraft, bool optInAgreed, bool isSaving, String? formErrorKey, bool allDataIsLoaded
});




}
/// @nodoc
class _$PredictorLeaderboardPageViewModelCopyWithImpl<$Res>
    implements $PredictorLeaderboardPageViewModelCopyWith<$Res> {
  _$PredictorLeaderboardPageViewModelCopyWithImpl(this._self, this._then);

  final PredictorLeaderboardPageViewModel _self;
  final $Res Function(PredictorLeaderboardPageViewModel) _then;

/// Create a copy of PredictorLeaderboardPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,Object? entries = null,Object? nicknameDraft = null,Object? optInAgreed = null,Object? isSaving = null,Object? formErrorKey = freezed,Object? allDataIsLoaded = null,}) {
  return _then(_self.copyWith(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as PredictorLeaderboardProfile,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as Loadable<List<PredictorLeaderboardEntry>>,nicknameDraft: null == nicknameDraft ? _self.nicknameDraft : nicknameDraft // ignore: cast_nullable_to_non_nullable
as String,optInAgreed: null == optInAgreed ? _self.optInAgreed : optInAgreed // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,formErrorKey: freezed == formErrorKey ? _self.formErrorKey : formErrorKey // ignore: cast_nullable_to_non_nullable
as String?,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictorLeaderboardPageViewModel].
extension PredictorLeaderboardPageViewModelPatterns on PredictorLeaderboardPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictorLeaderboardPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictorLeaderboardPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictorLeaderboardPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _PredictorLeaderboardPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictorLeaderboardPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _PredictorLeaderboardPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PredictorLeaderboardProfile profile,  Loadable<List<PredictorLeaderboardEntry>> entries,  String nicknameDraft,  bool optInAgreed,  bool isSaving,  String? formErrorKey,  bool allDataIsLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictorLeaderboardPageViewModel() when $default != null:
return $default(_that.profile,_that.entries,_that.nicknameDraft,_that.optInAgreed,_that.isSaving,_that.formErrorKey,_that.allDataIsLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PredictorLeaderboardProfile profile,  Loadable<List<PredictorLeaderboardEntry>> entries,  String nicknameDraft,  bool optInAgreed,  bool isSaving,  String? formErrorKey,  bool allDataIsLoaded)  $default,) {final _that = this;
switch (_that) {
case _PredictorLeaderboardPageViewModel():
return $default(_that.profile,_that.entries,_that.nicknameDraft,_that.optInAgreed,_that.isSaving,_that.formErrorKey,_that.allDataIsLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PredictorLeaderboardProfile profile,  Loadable<List<PredictorLeaderboardEntry>> entries,  String nicknameDraft,  bool optInAgreed,  bool isSaving,  String? formErrorKey,  bool allDataIsLoaded)?  $default,) {final _that = this;
switch (_that) {
case _PredictorLeaderboardPageViewModel() when $default != null:
return $default(_that.profile,_that.entries,_that.nicknameDraft,_that.optInAgreed,_that.isSaving,_that.formErrorKey,_that.allDataIsLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _PredictorLeaderboardPageViewModel extends PredictorLeaderboardPageViewModel {
  const _PredictorLeaderboardPageViewModel({this.profile = const PredictorLeaderboardProfile(), this.entries = const Loadable.loading(), this.nicknameDraft = '', this.optInAgreed = false, this.isSaving = false, this.formErrorKey, this.allDataIsLoaded = false}): super._();
  

/// Мой профиль на лидерборде.
@override@JsonKey() final  PredictorLeaderboardProfile profile;
/// Записи лидерборда.
@override@JsonKey() final  Loadable<List<PredictorLeaderboardEntry>> entries;
/// Черновик никнейма.
@override@JsonKey() final  String nicknameDraft;
/// Согласие на opt-in.
@override@JsonKey() final  bool optInAgreed;
/// Идёт сохранение.
@override@JsonKey() final  bool isSaving;
/// Ключ ошибки формы (локализация).
@override final  String? formErrorKey;
/// Данные полностью загружены.
@override@JsonKey() final  bool allDataIsLoaded;

/// Create a copy of PredictorLeaderboardPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictorLeaderboardPageViewModelCopyWith<_PredictorLeaderboardPageViewModel> get copyWith => __$PredictorLeaderboardPageViewModelCopyWithImpl<_PredictorLeaderboardPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictorLeaderboardPageViewModel&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.entries, entries) || other.entries == entries)&&(identical(other.nicknameDraft, nicknameDraft) || other.nicknameDraft == nicknameDraft)&&(identical(other.optInAgreed, optInAgreed) || other.optInAgreed == optInAgreed)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.formErrorKey, formErrorKey) || other.formErrorKey == formErrorKey)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,profile,entries,nicknameDraft,optInAgreed,isSaving,formErrorKey,allDataIsLoaded);

@override
String toString() {
  return 'PredictorLeaderboardPageViewModel(profile: $profile, entries: $entries, nicknameDraft: $nicknameDraft, optInAgreed: $optInAgreed, isSaving: $isSaving, formErrorKey: $formErrorKey, allDataIsLoaded: $allDataIsLoaded)';
}


}

/// @nodoc
abstract mixin class _$PredictorLeaderboardPageViewModelCopyWith<$Res> implements $PredictorLeaderboardPageViewModelCopyWith<$Res> {
  factory _$PredictorLeaderboardPageViewModelCopyWith(_PredictorLeaderboardPageViewModel value, $Res Function(_PredictorLeaderboardPageViewModel) _then) = __$PredictorLeaderboardPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 PredictorLeaderboardProfile profile, Loadable<List<PredictorLeaderboardEntry>> entries, String nicknameDraft, bool optInAgreed, bool isSaving, String? formErrorKey, bool allDataIsLoaded
});




}
/// @nodoc
class __$PredictorLeaderboardPageViewModelCopyWithImpl<$Res>
    implements _$PredictorLeaderboardPageViewModelCopyWith<$Res> {
  __$PredictorLeaderboardPageViewModelCopyWithImpl(this._self, this._then);

  final _PredictorLeaderboardPageViewModel _self;
  final $Res Function(_PredictorLeaderboardPageViewModel) _then;

/// Create a copy of PredictorLeaderboardPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? entries = null,Object? nicknameDraft = null,Object? optInAgreed = null,Object? isSaving = null,Object? formErrorKey = freezed,Object? allDataIsLoaded = null,}) {
  return _then(_PredictorLeaderboardPageViewModel(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as PredictorLeaderboardProfile,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as Loadable<List<PredictorLeaderboardEntry>>,nicknameDraft: null == nicknameDraft ? _self.nicknameDraft : nicknameDraft // ignore: cast_nullable_to_non_nullable
as String,optInAgreed: null == optInAgreed ? _self.optInAgreed : optInAgreed // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,formErrorKey: freezed == formErrorKey ? _self.formErrorKey : formErrorKey // ignore: cast_nullable_to_non_nullable
as String?,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
