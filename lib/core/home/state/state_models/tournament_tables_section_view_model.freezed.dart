// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_tables_section_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentTablesSectionViewModel {

/// Активная вкладка (0 — пилоты, 1 — конструкторы).
 int get activeTable;
/// Create a copy of TournamentTablesSectionViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentTablesSectionViewModelCopyWith<TournamentTablesSectionViewModel> get copyWith => _$TournamentTablesSectionViewModelCopyWithImpl<TournamentTablesSectionViewModel>(this as TournamentTablesSectionViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentTablesSectionViewModel&&(identical(other.activeTable, activeTable) || other.activeTable == activeTable));
}


@override
int get hashCode => Object.hash(runtimeType,activeTable);

@override
String toString() {
  return 'TournamentTablesSectionViewModel(activeTable: $activeTable)';
}


}

/// @nodoc
abstract mixin class $TournamentTablesSectionViewModelCopyWith<$Res>  {
  factory $TournamentTablesSectionViewModelCopyWith(TournamentTablesSectionViewModel value, $Res Function(TournamentTablesSectionViewModel) _then) = _$TournamentTablesSectionViewModelCopyWithImpl;
@useResult
$Res call({
 int activeTable
});




}
/// @nodoc
class _$TournamentTablesSectionViewModelCopyWithImpl<$Res>
    implements $TournamentTablesSectionViewModelCopyWith<$Res> {
  _$TournamentTablesSectionViewModelCopyWithImpl(this._self, this._then);

  final TournamentTablesSectionViewModel _self;
  final $Res Function(TournamentTablesSectionViewModel) _then;

/// Create a copy of TournamentTablesSectionViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeTable = null,}) {
  return _then(_self.copyWith(
activeTable: null == activeTable ? _self.activeTable : activeTable // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentTablesSectionViewModel].
extension TournamentTablesSectionViewModelPatterns on TournamentTablesSectionViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentTablesSectionViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentTablesSectionViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentTablesSectionViewModel value)  $default,){
final _that = this;
switch (_that) {
case _TournamentTablesSectionViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentTablesSectionViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentTablesSectionViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeTable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentTablesSectionViewModel() when $default != null:
return $default(_that.activeTable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeTable)  $default,) {final _that = this;
switch (_that) {
case _TournamentTablesSectionViewModel():
return $default(_that.activeTable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeTable)?  $default,) {final _that = this;
switch (_that) {
case _TournamentTablesSectionViewModel() when $default != null:
return $default(_that.activeTable);case _:
  return null;

}
}

}

/// @nodoc


class _TournamentTablesSectionViewModel implements TournamentTablesSectionViewModel {
  const _TournamentTablesSectionViewModel({this.activeTable = 0});
  

/// Активная вкладка (0 — пилоты, 1 — конструкторы).
@override@JsonKey() final  int activeTable;

/// Create a copy of TournamentTablesSectionViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentTablesSectionViewModelCopyWith<_TournamentTablesSectionViewModel> get copyWith => __$TournamentTablesSectionViewModelCopyWithImpl<_TournamentTablesSectionViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentTablesSectionViewModel&&(identical(other.activeTable, activeTable) || other.activeTable == activeTable));
}


@override
int get hashCode => Object.hash(runtimeType,activeTable);

@override
String toString() {
  return 'TournamentTablesSectionViewModel(activeTable: $activeTable)';
}


}

/// @nodoc
abstract mixin class _$TournamentTablesSectionViewModelCopyWith<$Res> implements $TournamentTablesSectionViewModelCopyWith<$Res> {
  factory _$TournamentTablesSectionViewModelCopyWith(_TournamentTablesSectionViewModel value, $Res Function(_TournamentTablesSectionViewModel) _then) = __$TournamentTablesSectionViewModelCopyWithImpl;
@override @useResult
$Res call({
 int activeTable
});




}
/// @nodoc
class __$TournamentTablesSectionViewModelCopyWithImpl<$Res>
    implements _$TournamentTablesSectionViewModelCopyWith<$Res> {
  __$TournamentTablesSectionViewModelCopyWithImpl(this._self, this._then);

  final _TournamentTablesSectionViewModel _self;
  final $Res Function(_TournamentTablesSectionViewModel) _then;

/// Create a copy of TournamentTablesSectionViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeTable = null,}) {
  return _then(_TournamentTablesSectionViewModel(
activeTable: null == activeTable ? _self.activeTable : activeTable // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
