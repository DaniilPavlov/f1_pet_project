// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsPageViewModel {

 Loadable<List<NewsArticleModel>> get articles; int get visibleCount;
/// Create a copy of NewsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsPageViewModelCopyWith<NewsPageViewModel> get copyWith => _$NewsPageViewModelCopyWithImpl<NewsPageViewModel>(this as NewsPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsPageViewModel&&(identical(other.articles, articles) || other.articles == articles)&&(identical(other.visibleCount, visibleCount) || other.visibleCount == visibleCount));
}


@override
int get hashCode => Object.hash(runtimeType,articles,visibleCount);

@override
String toString() {
  return 'NewsPageViewModel(articles: $articles, visibleCount: $visibleCount)';
}


}

/// @nodoc
abstract mixin class $NewsPageViewModelCopyWith<$Res>  {
  factory $NewsPageViewModelCopyWith(NewsPageViewModel value, $Res Function(NewsPageViewModel) _then) = _$NewsPageViewModelCopyWithImpl;
@useResult
$Res call({
 Loadable<List<NewsArticleModel>> articles, int visibleCount
});




}
/// @nodoc
class _$NewsPageViewModelCopyWithImpl<$Res>
    implements $NewsPageViewModelCopyWith<$Res> {
  _$NewsPageViewModelCopyWithImpl(this._self, this._then);

  final NewsPageViewModel _self;
  final $Res Function(NewsPageViewModel) _then;

/// Create a copy of NewsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articles = null,Object? visibleCount = null,}) {
  return _then(_self.copyWith(
articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as Loadable<List<NewsArticleModel>>,visibleCount: null == visibleCount ? _self.visibleCount : visibleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsPageViewModel].
extension NewsPageViewModelPatterns on NewsPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _NewsPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _NewsPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loadable<List<NewsArticleModel>> articles,  int visibleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsPageViewModel() when $default != null:
return $default(_that.articles,_that.visibleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loadable<List<NewsArticleModel>> articles,  int visibleCount)  $default,) {final _that = this;
switch (_that) {
case _NewsPageViewModel():
return $default(_that.articles,_that.visibleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loadable<List<NewsArticleModel>> articles,  int visibleCount)?  $default,) {final _that = this;
switch (_that) {
case _NewsPageViewModel() when $default != null:
return $default(_that.articles,_that.visibleCount);case _:
  return null;

}
}

}

/// @nodoc


class _NewsPageViewModel extends NewsPageViewModel {
  const _NewsPageViewModel({this.articles = const Loadable.loading(), this.visibleCount = newsPageSize}): super._();
  

@override@JsonKey() final  Loadable<List<NewsArticleModel>> articles;
@override@JsonKey() final  int visibleCount;

/// Create a copy of NewsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsPageViewModelCopyWith<_NewsPageViewModel> get copyWith => __$NewsPageViewModelCopyWithImpl<_NewsPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsPageViewModel&&(identical(other.articles, articles) || other.articles == articles)&&(identical(other.visibleCount, visibleCount) || other.visibleCount == visibleCount));
}


@override
int get hashCode => Object.hash(runtimeType,articles,visibleCount);

@override
String toString() {
  return 'NewsPageViewModel(articles: $articles, visibleCount: $visibleCount)';
}


}

/// @nodoc
abstract mixin class _$NewsPageViewModelCopyWith<$Res> implements $NewsPageViewModelCopyWith<$Res> {
  factory _$NewsPageViewModelCopyWith(_NewsPageViewModel value, $Res Function(_NewsPageViewModel) _then) = __$NewsPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 Loadable<List<NewsArticleModel>> articles, int visibleCount
});




}
/// @nodoc
class __$NewsPageViewModelCopyWithImpl<$Res>
    implements _$NewsPageViewModelCopyWith<$Res> {
  __$NewsPageViewModelCopyWithImpl(this._self, this._then);

  final _NewsPageViewModel _self;
  final $Res Function(_NewsPageViewModel) _then;

/// Create a copy of NewsPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articles = null,Object? visibleCount = null,}) {
  return _then(_NewsPageViewModel(
articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as Loadable<List<NewsArticleModel>>,visibleCount: null == visibleCount ? _self.visibleCount : visibleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
