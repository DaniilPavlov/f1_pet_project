// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BaseResponseModel {

/// Полезная нагрузка ответа (MRData).
@JsonKey(name: 'MRData') dynamic get mrData; String? get message; int? get code;
/// Create a copy of BaseResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseResponseModelCopyWith<BaseResponseModel> get copyWith => _$BaseResponseModelCopyWithImpl<BaseResponseModel>(this as BaseResponseModel, _$identity);

  /// Serializes this BaseResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseResponseModel&&const DeepCollectionEquality().equals(other.mrData, mrData)&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mrData),message,code);

@override
String toString() {
  return 'BaseResponseModel(mrData: $mrData, message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $BaseResponseModelCopyWith<$Res>  {
  factory $BaseResponseModelCopyWith(BaseResponseModel value, $Res Function(BaseResponseModel) _then) = _$BaseResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'MRData') dynamic mrData, String? message, int? code
});




}
/// @nodoc
class _$BaseResponseModelCopyWithImpl<$Res>
    implements $BaseResponseModelCopyWith<$Res> {
  _$BaseResponseModelCopyWithImpl(this._self, this._then);

  final BaseResponseModel _self;
  final $Res Function(BaseResponseModel) _then;

/// Create a copy of BaseResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mrData = freezed,Object? message = freezed,Object? code = freezed,}) {
  return _then(_self.copyWith(
mrData: freezed == mrData ? _self.mrData : mrData // ignore: cast_nullable_to_non_nullable
as dynamic,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseResponseModel].
extension BaseResponseModelPatterns on BaseResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _BaseResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _BaseResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'MRData')  dynamic mrData,  String? message,  int? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseResponseModel() when $default != null:
return $default(_that.mrData,_that.message,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'MRData')  dynamic mrData,  String? message,  int? code)  $default,) {final _that = this;
switch (_that) {
case _BaseResponseModel():
return $default(_that.mrData,_that.message,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'MRData')  dynamic mrData,  String? message,  int? code)?  $default,) {final _that = this;
switch (_that) {
case _BaseResponseModel() when $default != null:
return $default(_that.mrData,_that.message,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BaseResponseModel implements BaseResponseModel {
  const _BaseResponseModel({@JsonKey(name: 'MRData') required this.mrData, this.message, this.code});
  factory _BaseResponseModel.fromJson(Map<String, dynamic> json) => _$BaseResponseModelFromJson(json);

/// Полезная нагрузка ответа (MRData).
@override@JsonKey(name: 'MRData') final  dynamic mrData;
@override final  String? message;
@override final  int? code;

/// Create a copy of BaseResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseResponseModelCopyWith<_BaseResponseModel> get copyWith => __$BaseResponseModelCopyWithImpl<_BaseResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BaseResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseResponseModel&&const DeepCollectionEquality().equals(other.mrData, mrData)&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mrData),message,code);

@override
String toString() {
  return 'BaseResponseModel(mrData: $mrData, message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class _$BaseResponseModelCopyWith<$Res> implements $BaseResponseModelCopyWith<$Res> {
  factory _$BaseResponseModelCopyWith(_BaseResponseModel value, $Res Function(_BaseResponseModel) _then) = __$BaseResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'MRData') dynamic mrData, String? message, int? code
});




}
/// @nodoc
class __$BaseResponseModelCopyWithImpl<$Res>
    implements _$BaseResponseModelCopyWith<$Res> {
  __$BaseResponseModelCopyWithImpl(this._self, this._then);

  final _BaseResponseModel _self;
  final $Res Function(_BaseResponseModel) _then;

/// Create a copy of BaseResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mrData = freezed,Object? message = freezed,Object? code = freezed,}) {
  return _then(_BaseResponseModel(
mrData: freezed == mrData ? _self.mrData : mrData // ignore: cast_nullable_to_non_nullable
as dynamic,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
