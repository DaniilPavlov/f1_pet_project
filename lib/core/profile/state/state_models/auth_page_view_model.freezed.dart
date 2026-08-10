// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthPageViewModel {

 String get email; String get password; bool get isLoading; String? get errorKey;
/// Create a copy of AuthPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthPageViewModelCopyWith<AuthPageViewModel> get copyWith => _$AuthPageViewModelCopyWithImpl<AuthPageViewModel>(this as AuthPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthPageViewModel&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,isLoading,errorKey);

@override
String toString() {
  return 'AuthPageViewModel(email: $email, password: $password, isLoading: $isLoading, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $AuthPageViewModelCopyWith<$Res>  {
  factory $AuthPageViewModelCopyWith(AuthPageViewModel value, $Res Function(AuthPageViewModel) _then) = _$AuthPageViewModelCopyWithImpl;
@useResult
$Res call({
 String email, String password, bool isLoading, String? errorKey
});




}
/// @nodoc
class _$AuthPageViewModelCopyWithImpl<$Res>
    implements $AuthPageViewModelCopyWith<$Res> {
  _$AuthPageViewModelCopyWithImpl(this._self, this._then);

  final AuthPageViewModel _self;
  final $Res Function(AuthPageViewModel) _then;

/// Create a copy of AuthPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? isLoading = null,Object? errorKey = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthPageViewModel].
extension AuthPageViewModelPatterns on AuthPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password,  bool isLoading,  String? errorKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthPageViewModel() when $default != null:
return $default(_that.email,_that.password,_that.isLoading,_that.errorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password,  bool isLoading,  String? errorKey)  $default,) {final _that = this;
switch (_that) {
case _AuthPageViewModel():
return $default(_that.email,_that.password,_that.isLoading,_that.errorKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password,  bool isLoading,  String? errorKey)?  $default,) {final _that = this;
switch (_that) {
case _AuthPageViewModel() when $default != null:
return $default(_that.email,_that.password,_that.isLoading,_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class _AuthPageViewModel implements AuthPageViewModel {
  const _AuthPageViewModel({this.email = '', this.password = '', this.isLoading = false, this.errorKey});
  

@override@JsonKey() final  String email;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool isLoading;
@override final  String? errorKey;

/// Create a copy of AuthPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthPageViewModelCopyWith<_AuthPageViewModel> get copyWith => __$AuthPageViewModelCopyWithImpl<_AuthPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthPageViewModel&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,isLoading,errorKey);

@override
String toString() {
  return 'AuthPageViewModel(email: $email, password: $password, isLoading: $isLoading, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class _$AuthPageViewModelCopyWith<$Res> implements $AuthPageViewModelCopyWith<$Res> {
  factory _$AuthPageViewModelCopyWith(_AuthPageViewModel value, $Res Function(_AuthPageViewModel) _then) = __$AuthPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 String email, String password, bool isLoading, String? errorKey
});




}
/// @nodoc
class __$AuthPageViewModelCopyWithImpl<$Res>
    implements _$AuthPageViewModelCopyWith<$Res> {
  __$AuthPageViewModelCopyWithImpl(this._self, this._then);

  final _AuthPageViewModel _self;
  final $Res Function(_AuthPageViewModel) _then;

/// Create a copy of AuthPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? isLoading = null,Object? errorKey = freezed,}) {
  return _then(_AuthPageViewModel(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
