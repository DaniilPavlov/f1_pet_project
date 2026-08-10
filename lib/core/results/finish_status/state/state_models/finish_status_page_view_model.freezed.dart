// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finish_status_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinishStatusPageViewModel {

 Loadable<List<FinishStatusItem>> get statuses;
/// Create a copy of FinishStatusPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishStatusPageViewModelCopyWith<FinishStatusPageViewModel> get copyWith => _$FinishStatusPageViewModelCopyWithImpl<FinishStatusPageViewModel>(this as FinishStatusPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishStatusPageViewModel&&(identical(other.statuses, statuses) || other.statuses == statuses));
}


@override
int get hashCode => Object.hash(runtimeType,statuses);

@override
String toString() {
  return 'FinishStatusPageViewModel(statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class $FinishStatusPageViewModelCopyWith<$Res>  {
  factory $FinishStatusPageViewModelCopyWith(FinishStatusPageViewModel value, $Res Function(FinishStatusPageViewModel) _then) = _$FinishStatusPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<List<FinishStatusItem>> statuses
});




}
/// @nodoc
class _$FinishStatusPageViewModelCopyWithImpl<$Res>
    implements $FinishStatusPageViewModelCopyWith<$Res> {
  _$FinishStatusPageViewModelCopyWithImpl(this._self, this._then);

  final FinishStatusPageViewModel _self;
  final $Res Function(FinishStatusPageViewModel) _then;

/// Create a copy of FinishStatusPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statuses = null,}) {
  return _then(_self.copyWith(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as Loadable<List<FinishStatusItem>>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinishStatusPageViewModel].
extension FinishStatusPageViewModelPatterns on FinishStatusPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishStatusPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishStatusPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishStatusPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _FinishStatusPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishStatusPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _FinishStatusPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<List<FinishStatusItem>> statuses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishStatusPageViewModel() when $default != null:
return $default(_that.statuses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<List<FinishStatusItem>> statuses)  $default,) {final _that = this;
switch (_that) {
case _FinishStatusPageViewModel():
return $default(_that.statuses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<List<FinishStatusItem>> statuses)?  $default,) {final _that = this;
switch (_that) {
case _FinishStatusPageViewModel() when $default != null:
return $default(_that.statuses);case _:
  return null;

}
}

}

/// @nodoc


class _FinishStatusPageViewModel extends FinishStatusPageViewModel {
  const _FinishStatusPageViewModel({this.statuses = const Loadable.loading()}): super._();
  

@override@JsonKey() final  Loadable<List<FinishStatusItem>> statuses;

/// Create a copy of FinishStatusPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishStatusPageViewModelCopyWith<_FinishStatusPageViewModel> get copyWith => __$FinishStatusPageViewModelCopyWithImpl<_FinishStatusPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishStatusPageViewModel&&(identical(other.statuses, statuses) || other.statuses == statuses));
}


@override
int get hashCode => Object.hash(runtimeType,statuses);

@override
String toString() {
  return 'FinishStatusPageViewModel(statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class _$FinishStatusPageViewModelCopyWith<$Res> implements $FinishStatusPageViewModelCopyWith<$Res> {
  factory _$FinishStatusPageViewModelCopyWith(_FinishStatusPageViewModel value, $Res Function(_FinishStatusPageViewModel) _then) = __$FinishStatusPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<List<FinishStatusItem>> statuses
});




}
/// @nodoc
class __$FinishStatusPageViewModelCopyWithImpl<$Res>
    implements _$FinishStatusPageViewModelCopyWith<$Res> {
  __$FinishStatusPageViewModelCopyWithImpl(this._self, this._then);

  final _FinishStatusPageViewModel _self;
  final $Res Function(_FinishStatusPageViewModel) _then;

/// Create a copy of FinishStatusPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,}) {
  return _then(_FinishStatusPageViewModel(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as Loadable<List<FinishStatusItem>>,
  ));
}


}

// dart format on
