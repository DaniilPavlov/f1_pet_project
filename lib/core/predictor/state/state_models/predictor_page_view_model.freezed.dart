// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predictor_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PredictorPageViewModel {

 DateTime get now; Loadable<List<RacesModel>> get races; Loadable<List<DriverModel>> get drivers; Map<String, ConstructorModel> get constructorsByDriverId; List<String> get championshipDriverOrder; PredictorStore get store; Loadable<PredictorStore> get predictions; bool get allDataIsLoaded; PredictorGridKind get selectedGrid; List<String> get draftQualifyingOrder; List<String> get draftRaceOrder;
/// Create a copy of PredictorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictorPageViewModelCopyWith<PredictorPageViewModel> get copyWith => _$PredictorPageViewModelCopyWithImpl<PredictorPageViewModel>(this as PredictorPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictorPageViewModel&&(identical(other.now, now) || other.now == now)&&(identical(other.races, races) || other.races == races)&&(identical(other.drivers, drivers) || other.drivers == drivers)&&const DeepCollectionEquality().equals(other.constructorsByDriverId, constructorsByDriverId)&&const DeepCollectionEquality().equals(other.championshipDriverOrder, championshipDriverOrder)&&(identical(other.store, store) || other.store == store)&&(identical(other.predictions, predictions) || other.predictions == predictions)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded)&&(identical(other.selectedGrid, selectedGrid) || other.selectedGrid == selectedGrid)&&const DeepCollectionEquality().equals(other.draftQualifyingOrder, draftQualifyingOrder)&&const DeepCollectionEquality().equals(other.draftRaceOrder, draftRaceOrder));
}


@override
int get hashCode => Object.hash(runtimeType,now,races,drivers,const DeepCollectionEquality().hash(constructorsByDriverId),const DeepCollectionEquality().hash(championshipDriverOrder),store,predictions,allDataIsLoaded,selectedGrid,const DeepCollectionEquality().hash(draftQualifyingOrder),const DeepCollectionEquality().hash(draftRaceOrder));

@override
String toString() {
  return 'PredictorPageViewModel(now: $now, races: $races, drivers: $drivers, constructorsByDriverId: $constructorsByDriverId, championshipDriverOrder: $championshipDriverOrder, store: $store, predictions: $predictions, allDataIsLoaded: $allDataIsLoaded, selectedGrid: $selectedGrid, draftQualifyingOrder: $draftQualifyingOrder, draftRaceOrder: $draftRaceOrder)';
}


}

/// @nodoc
abstract mixin class $PredictorPageViewModelCopyWith<$Res>  {
  factory $PredictorPageViewModelCopyWith(PredictorPageViewModel value, $Res Function(PredictorPageViewModel) _then) = _$PredictorPageViewModelCopyWithImpl;
@useResult
$Res call({
 DateTime now, Loadable<List<RacesModel>> races, Loadable<List<DriverModel>> drivers, Map<String, ConstructorModel> constructorsByDriverId, List<String> championshipDriverOrder, PredictorStore store, Loadable<PredictorStore> predictions, bool allDataIsLoaded, PredictorGridKind selectedGrid, List<String> draftQualifyingOrder, List<String> draftRaceOrder
});




}
/// @nodoc
class _$PredictorPageViewModelCopyWithImpl<$Res>
    implements $PredictorPageViewModelCopyWith<$Res> {
  _$PredictorPageViewModelCopyWithImpl(this._self, this._then);

  final PredictorPageViewModel _self;
  final $Res Function(PredictorPageViewModel) _then;

/// Create a copy of PredictorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? now = null,Object? races = null,Object? drivers = null,Object? constructorsByDriverId = null,Object? championshipDriverOrder = null,Object? store = null,Object? predictions = null,Object? allDataIsLoaded = null,Object? selectedGrid = null,Object? draftQualifyingOrder = null,Object? draftRaceOrder = null,}) {
  return _then(_self.copyWith(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,races: null == races ? _self.races : races // ignore: cast_nullable_to_non_nullable
as Loadable<List<RacesModel>>,drivers: null == drivers ? _self.drivers : drivers // ignore: cast_nullable_to_non_nullable
as Loadable<List<DriverModel>>,constructorsByDriverId: null == constructorsByDriverId ? _self.constructorsByDriverId : constructorsByDriverId // ignore: cast_nullable_to_non_nullable
as Map<String, ConstructorModel>,championshipDriverOrder: null == championshipDriverOrder ? _self.championshipDriverOrder : championshipDriverOrder // ignore: cast_nullable_to_non_nullable
as List<String>,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PredictorStore,predictions: null == predictions ? _self.predictions : predictions // ignore: cast_nullable_to_non_nullable
as Loadable<PredictorStore>,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,selectedGrid: null == selectedGrid ? _self.selectedGrid : selectedGrid // ignore: cast_nullable_to_non_nullable
as PredictorGridKind,draftQualifyingOrder: null == draftQualifyingOrder ? _self.draftQualifyingOrder : draftQualifyingOrder // ignore: cast_nullable_to_non_nullable
as List<String>,draftRaceOrder: null == draftRaceOrder ? _self.draftRaceOrder : draftRaceOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictorPageViewModel].
extension PredictorPageViewModelPatterns on PredictorPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictorPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictorPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictorPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _PredictorPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictorPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _PredictorPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime now,  Loadable<List<RacesModel>> races,  Loadable<List<DriverModel>> drivers,  Map<String, ConstructorModel> constructorsByDriverId,  List<String> championshipDriverOrder,  PredictorStore store,  Loadable<PredictorStore> predictions,  bool allDataIsLoaded,  PredictorGridKind selectedGrid,  List<String> draftQualifyingOrder,  List<String> draftRaceOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictorPageViewModel() when $default != null:
return $default(_that.now,_that.races,_that.drivers,_that.constructorsByDriverId,_that.championshipDriverOrder,_that.store,_that.predictions,_that.allDataIsLoaded,_that.selectedGrid,_that.draftQualifyingOrder,_that.draftRaceOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime now,  Loadable<List<RacesModel>> races,  Loadable<List<DriverModel>> drivers,  Map<String, ConstructorModel> constructorsByDriverId,  List<String> championshipDriverOrder,  PredictorStore store,  Loadable<PredictorStore> predictions,  bool allDataIsLoaded,  PredictorGridKind selectedGrid,  List<String> draftQualifyingOrder,  List<String> draftRaceOrder)  $default,) {final _that = this;
switch (_that) {
case _PredictorPageViewModel():
return $default(_that.now,_that.races,_that.drivers,_that.constructorsByDriverId,_that.championshipDriverOrder,_that.store,_that.predictions,_that.allDataIsLoaded,_that.selectedGrid,_that.draftQualifyingOrder,_that.draftRaceOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime now,  Loadable<List<RacesModel>> races,  Loadable<List<DriverModel>> drivers,  Map<String, ConstructorModel> constructorsByDriverId,  List<String> championshipDriverOrder,  PredictorStore store,  Loadable<PredictorStore> predictions,  bool allDataIsLoaded,  PredictorGridKind selectedGrid,  List<String> draftQualifyingOrder,  List<String> draftRaceOrder)?  $default,) {final _that = this;
switch (_that) {
case _PredictorPageViewModel() when $default != null:
return $default(_that.now,_that.races,_that.drivers,_that.constructorsByDriverId,_that.championshipDriverOrder,_that.store,_that.predictions,_that.allDataIsLoaded,_that.selectedGrid,_that.draftQualifyingOrder,_that.draftRaceOrder);case _:
  return null;

}
}

}

/// @nodoc


class _PredictorPageViewModel extends PredictorPageViewModel {
  const _PredictorPageViewModel({required this.now, this.races = const Loadable.loading(), this.drivers = const Loadable.loading(), final  Map<String, ConstructorModel> constructorsByDriverId = const <String, ConstructorModel>{}, final  List<String> championshipDriverOrder = const <String>[], this.store = const PredictorStore(seasons: {}), this.predictions = const Loadable.loading(), this.allDataIsLoaded = false, this.selectedGrid = PredictorGridKind.qualifying, final  List<String> draftQualifyingOrder = const <String>[], final  List<String> draftRaceOrder = const <String>[]}): _constructorsByDriverId = constructorsByDriverId,_championshipDriverOrder = championshipDriverOrder,_draftQualifyingOrder = draftQualifyingOrder,_draftRaceOrder = draftRaceOrder,super._();
  

@override final  DateTime now;
@override@JsonKey() final  Loadable<List<RacesModel>> races;
@override@JsonKey() final  Loadable<List<DriverModel>> drivers;
 final  Map<String, ConstructorModel> _constructorsByDriverId;
@override@JsonKey() Map<String, ConstructorModel> get constructorsByDriverId {
  if (_constructorsByDriverId is EqualUnmodifiableMapView) return _constructorsByDriverId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_constructorsByDriverId);
}

 final  List<String> _championshipDriverOrder;
@override@JsonKey() List<String> get championshipDriverOrder {
  if (_championshipDriverOrder is EqualUnmodifiableListView) return _championshipDriverOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_championshipDriverOrder);
}

@override@JsonKey() final  PredictorStore store;
@override@JsonKey() final  Loadable<PredictorStore> predictions;
@override@JsonKey() final  bool allDataIsLoaded;
@override@JsonKey() final  PredictorGridKind selectedGrid;
 final  List<String> _draftQualifyingOrder;
@override@JsonKey() List<String> get draftQualifyingOrder {
  if (_draftQualifyingOrder is EqualUnmodifiableListView) return _draftQualifyingOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_draftQualifyingOrder);
}

 final  List<String> _draftRaceOrder;
@override@JsonKey() List<String> get draftRaceOrder {
  if (_draftRaceOrder is EqualUnmodifiableListView) return _draftRaceOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_draftRaceOrder);
}


/// Create a copy of PredictorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictorPageViewModelCopyWith<_PredictorPageViewModel> get copyWith => __$PredictorPageViewModelCopyWithImpl<_PredictorPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictorPageViewModel&&(identical(other.now, now) || other.now == now)&&(identical(other.races, races) || other.races == races)&&(identical(other.drivers, drivers) || other.drivers == drivers)&&const DeepCollectionEquality().equals(other._constructorsByDriverId, _constructorsByDriverId)&&const DeepCollectionEquality().equals(other._championshipDriverOrder, _championshipDriverOrder)&&(identical(other.store, store) || other.store == store)&&(identical(other.predictions, predictions) || other.predictions == predictions)&&(identical(other.allDataIsLoaded, allDataIsLoaded) || other.allDataIsLoaded == allDataIsLoaded)&&(identical(other.selectedGrid, selectedGrid) || other.selectedGrid == selectedGrid)&&const DeepCollectionEquality().equals(other._draftQualifyingOrder, _draftQualifyingOrder)&&const DeepCollectionEquality().equals(other._draftRaceOrder, _draftRaceOrder));
}


@override
int get hashCode => Object.hash(runtimeType,now,races,drivers,const DeepCollectionEquality().hash(_constructorsByDriverId),const DeepCollectionEquality().hash(_championshipDriverOrder),store,predictions,allDataIsLoaded,selectedGrid,const DeepCollectionEquality().hash(_draftQualifyingOrder),const DeepCollectionEquality().hash(_draftRaceOrder));

@override
String toString() {
  return 'PredictorPageViewModel(now: $now, races: $races, drivers: $drivers, constructorsByDriverId: $constructorsByDriverId, championshipDriverOrder: $championshipDriverOrder, store: $store, predictions: $predictions, allDataIsLoaded: $allDataIsLoaded, selectedGrid: $selectedGrid, draftQualifyingOrder: $draftQualifyingOrder, draftRaceOrder: $draftRaceOrder)';
}


}

/// @nodoc
abstract mixin class _$PredictorPageViewModelCopyWith<$Res> implements $PredictorPageViewModelCopyWith<$Res> {
  factory _$PredictorPageViewModelCopyWith(_PredictorPageViewModel value, $Res Function(_PredictorPageViewModel) _then) = __$PredictorPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime now, Loadable<List<RacesModel>> races, Loadable<List<DriverModel>> drivers, Map<String, ConstructorModel> constructorsByDriverId, List<String> championshipDriverOrder, PredictorStore store, Loadable<PredictorStore> predictions, bool allDataIsLoaded, PredictorGridKind selectedGrid, List<String> draftQualifyingOrder, List<String> draftRaceOrder
});




}
/// @nodoc
class __$PredictorPageViewModelCopyWithImpl<$Res>
    implements _$PredictorPageViewModelCopyWith<$Res> {
  __$PredictorPageViewModelCopyWithImpl(this._self, this._then);

  final _PredictorPageViewModel _self;
  final $Res Function(_PredictorPageViewModel) _then;

/// Create a copy of PredictorPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? now = null,Object? races = null,Object? drivers = null,Object? constructorsByDriverId = null,Object? championshipDriverOrder = null,Object? store = null,Object? predictions = null,Object? allDataIsLoaded = null,Object? selectedGrid = null,Object? draftQualifyingOrder = null,Object? draftRaceOrder = null,}) {
  return _then(_PredictorPageViewModel(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,races: null == races ? _self.races : races // ignore: cast_nullable_to_non_nullable
as Loadable<List<RacesModel>>,drivers: null == drivers ? _self.drivers : drivers // ignore: cast_nullable_to_non_nullable
as Loadable<List<DriverModel>>,constructorsByDriverId: null == constructorsByDriverId ? _self._constructorsByDriverId : constructorsByDriverId // ignore: cast_nullable_to_non_nullable
as Map<String, ConstructorModel>,championshipDriverOrder: null == championshipDriverOrder ? _self._championshipDriverOrder : championshipDriverOrder // ignore: cast_nullable_to_non_nullable
as List<String>,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PredictorStore,predictions: null == predictions ? _self.predictions : predictions // ignore: cast_nullable_to_non_nullable
as Loadable<PredictorStore>,allDataIsLoaded: null == allDataIsLoaded ? _self.allDataIsLoaded : allDataIsLoaded // ignore: cast_nullable_to_non_nullable
as bool,selectedGrid: null == selectedGrid ? _self.selectedGrid : selectedGrid // ignore: cast_nullable_to_non_nullable
as PredictorGridKind,draftQualifyingOrder: null == draftQualifyingOrder ? _self._draftQualifyingOrder : draftQualifyingOrder // ignore: cast_nullable_to_non_nullable
as List<String>,draftRaceOrder: null == draftRaceOrder ? _self._draftRaceOrder : draftRaceOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
