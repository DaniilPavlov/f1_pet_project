// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circuits_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CircuitsPageViewModel {

 int get activePage;
/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitsPageViewModelCopyWith<CircuitsPageViewModel> get copyWith => _$CircuitsPageViewModelCopyWithImpl<CircuitsPageViewModel>(this as CircuitsPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitsPageViewModel&&(identical(other.activePage, activePage) || other.activePage == activePage));
}


@override
int get hashCode => Object.hash(runtimeType,activePage);

@override
String toString() {
  return 'CircuitsPageViewModel(activePage: $activePage)';
}


}

/// @nodoc
abstract mixin class $CircuitsPageViewModelCopyWith<$Res>  {
  factory $CircuitsPageViewModelCopyWith(CircuitsPageViewModel value, $Res Function(CircuitsPageViewModel) _then) = _$CircuitsPageViewModelCopyWithImpl;
@useResult
$Res call({
 int activePage
});




}
/// @nodoc
class _$CircuitsPageViewModelCopyWithImpl<$Res>
    implements $CircuitsPageViewModelCopyWith<$Res> {
  _$CircuitsPageViewModelCopyWithImpl(this._self, this._then);

  final CircuitsPageViewModel _self;
  final $Res Function(CircuitsPageViewModel) _then;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activePage = null,}) {
  return _then(_self.copyWith(
activePage: null == activePage ? _self.activePage : activePage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CircuitsPageViewModel].
extension CircuitsPageViewModelPatterns on CircuitsPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CircuitsPageLoading value)?  loading,TResult Function( CircuitsPageError value)?  error,TResult Function( CircuitsPageSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CircuitsPageLoading() when loading != null:
return loading(_that);case CircuitsPageError() when error != null:
return error(_that);case CircuitsPageSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CircuitsPageLoading value)  loading,required TResult Function( CircuitsPageError value)  error,required TResult Function( CircuitsPageSuccess value)  success,}){
final _that = this;
switch (_that) {
case CircuitsPageLoading():
return loading(_that);case CircuitsPageError():
return error(_that);case CircuitsPageSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CircuitsPageLoading value)?  loading,TResult? Function( CircuitsPageError value)?  error,TResult? Function( CircuitsPageSuccess value)?  success,}){
final _that = this;
switch (_that) {
case CircuitsPageLoading() when loading != null:
return loading(_that);case CircuitsPageError() when error != null:
return error(_that);case CircuitsPageSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int activePage)?  loading,TResult Function( CustomException exception,  int activePage)?  error,TResult Function( List<CircuitModel> circuits,  int activePage,  bool showingCachedData)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CircuitsPageLoading() when loading != null:
return loading(_that.activePage);case CircuitsPageError() when error != null:
return error(_that.exception,_that.activePage);case CircuitsPageSuccess() when success != null:
return success(_that.circuits,_that.activePage,_that.showingCachedData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int activePage)  loading,required TResult Function( CustomException exception,  int activePage)  error,required TResult Function( List<CircuitModel> circuits,  int activePage,  bool showingCachedData)  success,}) {final _that = this;
switch (_that) {
case CircuitsPageLoading():
return loading(_that.activePage);case CircuitsPageError():
return error(_that.exception,_that.activePage);case CircuitsPageSuccess():
return success(_that.circuits,_that.activePage,_that.showingCachedData);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int activePage)?  loading,TResult? Function( CustomException exception,  int activePage)?  error,TResult? Function( List<CircuitModel> circuits,  int activePage,  bool showingCachedData)?  success,}) {final _that = this;
switch (_that) {
case CircuitsPageLoading() when loading != null:
return loading(_that.activePage);case CircuitsPageError() when error != null:
return error(_that.exception,_that.activePage);case CircuitsPageSuccess() when success != null:
return success(_that.circuits,_that.activePage,_that.showingCachedData);case _:
  return null;

}
}

}

/// @nodoc


class CircuitsPageLoading extends CircuitsPageViewModel {
  const CircuitsPageLoading({this.activePage = 0}): super._();
  

@override@JsonKey() final  int activePage;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitsPageLoadingCopyWith<CircuitsPageLoading> get copyWith => _$CircuitsPageLoadingCopyWithImpl<CircuitsPageLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitsPageLoading&&(identical(other.activePage, activePage) || other.activePage == activePage));
}


@override
int get hashCode => Object.hash(runtimeType,activePage);

@override
String toString() {
  return 'CircuitsPageViewModel.loading(activePage: $activePage)';
}


}

/// @nodoc
abstract mixin class $CircuitsPageLoadingCopyWith<$Res> implements $CircuitsPageViewModelCopyWith<$Res> {
  factory $CircuitsPageLoadingCopyWith(CircuitsPageLoading value, $Res Function(CircuitsPageLoading) _then) = _$CircuitsPageLoadingCopyWithImpl;
@override @useResult
$Res call({
 int activePage
});




}
/// @nodoc
class _$CircuitsPageLoadingCopyWithImpl<$Res>
    implements $CircuitsPageLoadingCopyWith<$Res> {
  _$CircuitsPageLoadingCopyWithImpl(this._self, this._then);

  final CircuitsPageLoading _self;
  final $Res Function(CircuitsPageLoading) _then;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activePage = null,}) {
  return _then(CircuitsPageLoading(
activePage: null == activePage ? _self.activePage : activePage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CircuitsPageError extends CircuitsPageViewModel {
  const CircuitsPageError({required this.exception, this.activePage = 0}): super._();
  

 final  CustomException exception;
@override@JsonKey() final  int activePage;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitsPageErrorCopyWith<CircuitsPageError> get copyWith => _$CircuitsPageErrorCopyWithImpl<CircuitsPageError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitsPageError&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.activePage, activePage) || other.activePage == activePage));
}


@override
int get hashCode => Object.hash(runtimeType,exception,activePage);

@override
String toString() {
  return 'CircuitsPageViewModel.error(exception: $exception, activePage: $activePage)';
}


}

/// @nodoc
abstract mixin class $CircuitsPageErrorCopyWith<$Res> implements $CircuitsPageViewModelCopyWith<$Res> {
  factory $CircuitsPageErrorCopyWith(CircuitsPageError value, $Res Function(CircuitsPageError) _then) = _$CircuitsPageErrorCopyWithImpl;
@override @useResult
$Res call({
 CustomException exception, int activePage
});




}
/// @nodoc
class _$CircuitsPageErrorCopyWithImpl<$Res>
    implements $CircuitsPageErrorCopyWith<$Res> {
  _$CircuitsPageErrorCopyWithImpl(this._self, this._then);

  final CircuitsPageError _self;
  final $Res Function(CircuitsPageError) _then;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exception = null,Object? activePage = null,}) {
  return _then(CircuitsPageError(
exception: null == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as CustomException,activePage: null == activePage ? _self.activePage : activePage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CircuitsPageSuccess extends CircuitsPageViewModel {
  const CircuitsPageSuccess({required final  List<CircuitModel> circuits, this.activePage = 0, this.showingCachedData = false}): _circuits = circuits,super._();
  

 final  List<CircuitModel> _circuits;
 List<CircuitModel> get circuits {
  if (_circuits is EqualUnmodifiableListView) return _circuits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_circuits);
}

@override@JsonKey() final  int activePage;
@JsonKey() final  bool showingCachedData;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitsPageSuccessCopyWith<CircuitsPageSuccess> get copyWith => _$CircuitsPageSuccessCopyWithImpl<CircuitsPageSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitsPageSuccess&&const DeepCollectionEquality().equals(other._circuits, _circuits)&&(identical(other.activePage, activePage) || other.activePage == activePage)&&(identical(other.showingCachedData, showingCachedData) || other.showingCachedData == showingCachedData));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_circuits),activePage,showingCachedData);

@override
String toString() {
  return 'CircuitsPageViewModel.success(circuits: $circuits, activePage: $activePage, showingCachedData: $showingCachedData)';
}


}

/// @nodoc
abstract mixin class $CircuitsPageSuccessCopyWith<$Res> implements $CircuitsPageViewModelCopyWith<$Res> {
  factory $CircuitsPageSuccessCopyWith(CircuitsPageSuccess value, $Res Function(CircuitsPageSuccess) _then) = _$CircuitsPageSuccessCopyWithImpl;
@override @useResult
$Res call({
 List<CircuitModel> circuits, int activePage, bool showingCachedData
});




}
/// @nodoc
class _$CircuitsPageSuccessCopyWithImpl<$Res>
    implements $CircuitsPageSuccessCopyWith<$Res> {
  _$CircuitsPageSuccessCopyWithImpl(this._self, this._then);

  final CircuitsPageSuccess _self;
  final $Res Function(CircuitsPageSuccess) _then;

/// Create a copy of CircuitsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? circuits = null,Object? activePage = null,Object? showingCachedData = null,}) {
  return _then(CircuitsPageSuccess(
circuits: null == circuits ? _self._circuits : circuits // ignore: cast_nullable_to_non_nullable
as List<CircuitModel>,activePage: null == activePage ? _self.activePage : activePage // ignore: cast_nullable_to_non_nullable
as int,showingCachedData: null == showingCachedData ? _self.showingCachedData : showingCachedData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
