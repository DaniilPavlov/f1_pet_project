// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'constructor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConstructorModel {

 String get constructorId;@JsonKey(defaultValue: '') String get url; String get name;@JsonKey(defaultValue: '') String get nationality;
/// Create a copy of ConstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConstructorModelCopyWith<ConstructorModel> get copyWith => _$ConstructorModelCopyWithImpl<ConstructorModel>(this as ConstructorModel, _$identity);

  /// Serializes this ConstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConstructorModel&&(identical(other.constructorId, constructorId) || other.constructorId == constructorId)&&(identical(other.url, url) || other.url == url)&&(identical(other.name, name) || other.name == name)&&(identical(other.nationality, nationality) || other.nationality == nationality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,constructorId,url,name,nationality);

@override
String toString() {
  return 'ConstructorModel(constructorId: $constructorId, url: $url, name: $name, nationality: $nationality)';
}


}

/// @nodoc
abstract mixin class $ConstructorModelCopyWith<$Res>  {
  factory $ConstructorModelCopyWith(ConstructorModel value, $Res Function(ConstructorModel) _then) = _$ConstructorModelCopyWithImpl;
@useResult
$Res call({
 String constructorId,@JsonKey(defaultValue: '') String url, String name,@JsonKey(defaultValue: '') String nationality
});




}
/// @nodoc
class _$ConstructorModelCopyWithImpl<$Res>
    implements $ConstructorModelCopyWith<$Res> {
  _$ConstructorModelCopyWithImpl(this._self, this._then);

  final ConstructorModel _self;
  final $Res Function(ConstructorModel) _then;

/// Create a copy of ConstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? constructorId = null,Object? url = null,Object? name = null,Object? nationality = null,}) {
  return _then(_self.copyWith(
constructorId: null == constructorId ? _self.constructorId : constructorId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConstructorModel].
extension ConstructorModelPatterns on ConstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _ConstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String constructorId, @JsonKey(defaultValue: '')  String url,  String name, @JsonKey(defaultValue: '')  String nationality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConstructorModel() when $default != null:
return $default(_that.constructorId,_that.url,_that.name,_that.nationality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String constructorId, @JsonKey(defaultValue: '')  String url,  String name, @JsonKey(defaultValue: '')  String nationality)  $default,) {final _that = this;
switch (_that) {
case _ConstructorModel():
return $default(_that.constructorId,_that.url,_that.name,_that.nationality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String constructorId, @JsonKey(defaultValue: '')  String url,  String name, @JsonKey(defaultValue: '')  String nationality)?  $default,) {final _that = this;
switch (_that) {
case _ConstructorModel() when $default != null:
return $default(_that.constructorId,_that.url,_that.name,_that.nationality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConstructorModel implements ConstructorModel {
  const _ConstructorModel({required this.constructorId, @JsonKey(defaultValue: '') required this.url, required this.name, @JsonKey(defaultValue: '') required this.nationality});
  factory _ConstructorModel.fromJson(Map<String, dynamic> json) => _$ConstructorModelFromJson(json);

@override final  String constructorId;
@override@JsonKey(defaultValue: '') final  String url;
@override final  String name;
@override@JsonKey(defaultValue: '') final  String nationality;

/// Create a copy of ConstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConstructorModelCopyWith<_ConstructorModel> get copyWith => __$ConstructorModelCopyWithImpl<_ConstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConstructorModel&&(identical(other.constructorId, constructorId) || other.constructorId == constructorId)&&(identical(other.url, url) || other.url == url)&&(identical(other.name, name) || other.name == name)&&(identical(other.nationality, nationality) || other.nationality == nationality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,constructorId,url,name,nationality);

@override
String toString() {
  return 'ConstructorModel(constructorId: $constructorId, url: $url, name: $name, nationality: $nationality)';
}


}

/// @nodoc
abstract mixin class _$ConstructorModelCopyWith<$Res> implements $ConstructorModelCopyWith<$Res> {
  factory _$ConstructorModelCopyWith(_ConstructorModel value, $Res Function(_ConstructorModel) _then) = __$ConstructorModelCopyWithImpl;
@override @useResult
$Res call({
 String constructorId,@JsonKey(defaultValue: '') String url, String name,@JsonKey(defaultValue: '') String nationality
});




}
/// @nodoc
class __$ConstructorModelCopyWithImpl<$Res>
    implements _$ConstructorModelCopyWith<$Res> {
  __$ConstructorModelCopyWithImpl(this._self, this._then);

  final _ConstructorModel _self;
  final $Res Function(_ConstructorModel) _then;

/// Create a copy of ConstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? constructorId = null,Object? url = null,Object? name = null,Object? nationality = null,}) {
  return _then(_ConstructorModel(
constructorId: null == constructorId ? _self.constructorId : constructorId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
