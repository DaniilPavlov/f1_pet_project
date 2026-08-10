// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_preference_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsPreferenceViewModel {

 bool get userEnabled; bool get practiceRemindersEnabled; bool get isLoaded;
/// Create a copy of NotificationsPreferenceViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsPreferenceViewModelCopyWith<NotificationsPreferenceViewModel> get copyWith => _$NotificationsPreferenceViewModelCopyWithImpl<NotificationsPreferenceViewModel>(this as NotificationsPreferenceViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsPreferenceViewModel&&(identical(other.userEnabled, userEnabled) || other.userEnabled == userEnabled)&&(identical(other.practiceRemindersEnabled, practiceRemindersEnabled) || other.practiceRemindersEnabled == practiceRemindersEnabled)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,userEnabled,practiceRemindersEnabled,isLoaded);

@override
String toString() {
  return 'NotificationsPreferenceViewModel(userEnabled: $userEnabled, practiceRemindersEnabled: $practiceRemindersEnabled, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class $NotificationsPreferenceViewModelCopyWith<$Res>  {
  factory $NotificationsPreferenceViewModelCopyWith(NotificationsPreferenceViewModel value, $Res Function(NotificationsPreferenceViewModel) _then) = _$NotificationsPreferenceViewModelCopyWithImpl;
@useResult
$Res call({
 bool userEnabled, bool practiceRemindersEnabled, bool isLoaded
});




}
/// @nodoc
class _$NotificationsPreferenceViewModelCopyWithImpl<$Res>
    implements $NotificationsPreferenceViewModelCopyWith<$Res> {
  _$NotificationsPreferenceViewModelCopyWithImpl(this._self, this._then);

  final NotificationsPreferenceViewModel _self;
  final $Res Function(NotificationsPreferenceViewModel) _then;

/// Create a copy of NotificationsPreferenceViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userEnabled = null,Object? practiceRemindersEnabled = null,Object? isLoaded = null,}) {
  return _then(_self.copyWith(
userEnabled: null == userEnabled ? _self.userEnabled : userEnabled // ignore: cast_nullable_to_non_nullable
as bool,practiceRemindersEnabled: null == practiceRemindersEnabled ? _self.practiceRemindersEnabled : practiceRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationsPreferenceViewModel].
extension NotificationsPreferenceViewModelPatterns on NotificationsPreferenceViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsPreferenceViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsPreferenceViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsPreferenceViewModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsPreferenceViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsPreferenceViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsPreferenceViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool userEnabled,  bool practiceRemindersEnabled,  bool isLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsPreferenceViewModel() when $default != null:
return $default(_that.userEnabled,_that.practiceRemindersEnabled,_that.isLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool userEnabled,  bool practiceRemindersEnabled,  bool isLoaded)  $default,) {final _that = this;
switch (_that) {
case _NotificationsPreferenceViewModel():
return $default(_that.userEnabled,_that.practiceRemindersEnabled,_that.isLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool userEnabled,  bool practiceRemindersEnabled,  bool isLoaded)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsPreferenceViewModel() when $default != null:
return $default(_that.userEnabled,_that.practiceRemindersEnabled,_that.isLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsPreferenceViewModel extends NotificationsPreferenceViewModel {
  const _NotificationsPreferenceViewModel({this.userEnabled = true, this.practiceRemindersEnabled = true, this.isLoaded = false}): super._();
  

@override@JsonKey() final  bool userEnabled;
@override@JsonKey() final  bool practiceRemindersEnabled;
@override@JsonKey() final  bool isLoaded;

/// Create a copy of NotificationsPreferenceViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsPreferenceViewModelCopyWith<_NotificationsPreferenceViewModel> get copyWith => __$NotificationsPreferenceViewModelCopyWithImpl<_NotificationsPreferenceViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsPreferenceViewModel&&(identical(other.userEnabled, userEnabled) || other.userEnabled == userEnabled)&&(identical(other.practiceRemindersEnabled, practiceRemindersEnabled) || other.practiceRemindersEnabled == practiceRemindersEnabled)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,userEnabled,practiceRemindersEnabled,isLoaded);

@override
String toString() {
  return 'NotificationsPreferenceViewModel(userEnabled: $userEnabled, practiceRemindersEnabled: $practiceRemindersEnabled, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class _$NotificationsPreferenceViewModelCopyWith<$Res> implements $NotificationsPreferenceViewModelCopyWith<$Res> {
  factory _$NotificationsPreferenceViewModelCopyWith(_NotificationsPreferenceViewModel value, $Res Function(_NotificationsPreferenceViewModel) _then) = __$NotificationsPreferenceViewModelCopyWithImpl;
@override @useResult
$Res call({
 bool userEnabled, bool practiceRemindersEnabled, bool isLoaded
});




}
/// @nodoc
class __$NotificationsPreferenceViewModelCopyWithImpl<$Res>
    implements _$NotificationsPreferenceViewModelCopyWith<$Res> {
  __$NotificationsPreferenceViewModelCopyWithImpl(this._self, this._then);

  final _NotificationsPreferenceViewModel _self;
  final $Res Function(_NotificationsPreferenceViewModel) _then;

/// Create a copy of NotificationsPreferenceViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userEnabled = null,Object? practiceRemindersEnabled = null,Object? isLoaded = null,}) {
  return _then(_NotificationsPreferenceViewModel(
userEnabled: null == userEnabled ? _self.userEnabled : userEnabled // ignore: cast_nullable_to_non_nullable
as bool,practiceRemindersEnabled: null == practiceRemindersEnabled ? _self.practiceRemindersEnabled : practiceRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
