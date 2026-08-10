// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'races_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RacesModel {

 String get season; String get round; String get url; String get raceName;@JsonKey(name: 'Circuit') CircuitModel get circuit; String get date; String? get time;@JsonKey(name: 'FirstPractice') RaceDateModel? get firstPractice;@JsonKey(name: 'SecondPractice') RaceDateModel? get secondPractice;@JsonKey(name: 'ThirdPractice') RaceDateModel? get thirdPractice;@JsonKey(name: 'Qualifying') RaceDateModel? get qualifying;/// Дата и время спринт-квалификации (сетка на спринт).
@JsonKey(name: 'SprintQualifying') RaceDateModel? get sprintQualifying;@JsonKey(name: 'Sprint') RaceDateModel? get sprint;@JsonKey(name: 'Results') List<ResultsModel>? get results;@JsonKey(name: 'SprintResults') List<ResultsModel>? get sprintResults;@JsonKey(name: 'QualifyingResults') List<QualifyingResultsModel>? get qualifyingResults;@JsonKey(name: 'PitStops') List<PitStopsModel>? get pitStops;
/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RacesModelCopyWith<RacesModel> get copyWith => _$RacesModelCopyWithImpl<RacesModel>(this as RacesModel, _$identity);

  /// Serializes this RacesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RacesModel&&(identical(other.season, season) || other.season == season)&&(identical(other.round, round) || other.round == round)&&(identical(other.url, url) || other.url == url)&&(identical(other.raceName, raceName) || other.raceName == raceName)&&(identical(other.circuit, circuit) || other.circuit == circuit)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.firstPractice, firstPractice) || other.firstPractice == firstPractice)&&(identical(other.secondPractice, secondPractice) || other.secondPractice == secondPractice)&&(identical(other.thirdPractice, thirdPractice) || other.thirdPractice == thirdPractice)&&(identical(other.qualifying, qualifying) || other.qualifying == qualifying)&&(identical(other.sprintQualifying, sprintQualifying) || other.sprintQualifying == sprintQualifying)&&(identical(other.sprint, sprint) || other.sprint == sprint)&&const DeepCollectionEquality().equals(other.results, results)&&const DeepCollectionEquality().equals(other.sprintResults, sprintResults)&&const DeepCollectionEquality().equals(other.qualifyingResults, qualifyingResults)&&const DeepCollectionEquality().equals(other.pitStops, pitStops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,round,url,raceName,circuit,date,time,firstPractice,secondPractice,thirdPractice,qualifying,sprintQualifying,sprint,const DeepCollectionEquality().hash(results),const DeepCollectionEquality().hash(sprintResults),const DeepCollectionEquality().hash(qualifyingResults),const DeepCollectionEquality().hash(pitStops));

@override
String toString() {
  return 'RacesModel(season: $season, round: $round, url: $url, raceName: $raceName, circuit: $circuit, date: $date, time: $time, firstPractice: $firstPractice, secondPractice: $secondPractice, thirdPractice: $thirdPractice, qualifying: $qualifying, sprintQualifying: $sprintQualifying, sprint: $sprint, results: $results, sprintResults: $sprintResults, qualifyingResults: $qualifyingResults, pitStops: $pitStops)';
}


}

/// @nodoc
abstract mixin class $RacesModelCopyWith<$Res>  {
  factory $RacesModelCopyWith(RacesModel value, $Res Function(RacesModel) _then) = _$RacesModelCopyWithImpl;
@useResult
$Res call({
 String season, String round, String url, String raceName,@JsonKey(name: 'Circuit') CircuitModel circuit, String date, String? time,@JsonKey(name: 'FirstPractice') RaceDateModel? firstPractice,@JsonKey(name: 'SecondPractice') RaceDateModel? secondPractice,@JsonKey(name: 'ThirdPractice') RaceDateModel? thirdPractice,@JsonKey(name: 'Qualifying') RaceDateModel? qualifying,@JsonKey(name: 'SprintQualifying') RaceDateModel? sprintQualifying,@JsonKey(name: 'Sprint') RaceDateModel? sprint,@JsonKey(name: 'Results') List<ResultsModel>? results,@JsonKey(name: 'SprintResults') List<ResultsModel>? sprintResults,@JsonKey(name: 'QualifyingResults') List<QualifyingResultsModel>? qualifyingResults,@JsonKey(name: 'PitStops') List<PitStopsModel>? pitStops
});


$CircuitModelCopyWith<$Res> get circuit;$RaceDateModelCopyWith<$Res>? get firstPractice;$RaceDateModelCopyWith<$Res>? get secondPractice;$RaceDateModelCopyWith<$Res>? get thirdPractice;$RaceDateModelCopyWith<$Res>? get qualifying;$RaceDateModelCopyWith<$Res>? get sprintQualifying;$RaceDateModelCopyWith<$Res>? get sprint;

}
/// @nodoc
class _$RacesModelCopyWithImpl<$Res>
    implements $RacesModelCopyWith<$Res> {
  _$RacesModelCopyWithImpl(this._self, this._then);

  final RacesModel _self;
  final $Res Function(RacesModel) _then;

/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? season = null,Object? round = null,Object? url = null,Object? raceName = null,Object? circuit = null,Object? date = null,Object? time = freezed,Object? firstPractice = freezed,Object? secondPractice = freezed,Object? thirdPractice = freezed,Object? qualifying = freezed,Object? sprintQualifying = freezed,Object? sprint = freezed,Object? results = freezed,Object? sprintResults = freezed,Object? qualifyingResults = freezed,Object? pitStops = freezed,}) {
  return _then(_self.copyWith(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,raceName: null == raceName ? _self.raceName : raceName // ignore: cast_nullable_to_non_nullable
as String,circuit: null == circuit ? _self.circuit : circuit // ignore: cast_nullable_to_non_nullable
as CircuitModel,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,firstPractice: freezed == firstPractice ? _self.firstPractice : firstPractice // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,secondPractice: freezed == secondPractice ? _self.secondPractice : secondPractice // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,thirdPractice: freezed == thirdPractice ? _self.thirdPractice : thirdPractice // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,qualifying: freezed == qualifying ? _self.qualifying : qualifying // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,sprintQualifying: freezed == sprintQualifying ? _self.sprintQualifying : sprintQualifying // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,sprint: freezed == sprint ? _self.sprint : sprint // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ResultsModel>?,sprintResults: freezed == sprintResults ? _self.sprintResults : sprintResults // ignore: cast_nullable_to_non_nullable
as List<ResultsModel>?,qualifyingResults: freezed == qualifyingResults ? _self.qualifyingResults : qualifyingResults // ignore: cast_nullable_to_non_nullable
as List<QualifyingResultsModel>?,pitStops: freezed == pitStops ? _self.pitStops : pitStops // ignore: cast_nullable_to_non_nullable
as List<PitStopsModel>?,
  ));
}
/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CircuitModelCopyWith<$Res> get circuit {
  
  return $CircuitModelCopyWith<$Res>(_self.circuit, (value) {
    return _then(_self.copyWith(circuit: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get firstPractice {
    if (_self.firstPractice == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.firstPractice!, (value) {
    return _then(_self.copyWith(firstPractice: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get secondPractice {
    if (_self.secondPractice == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.secondPractice!, (value) {
    return _then(_self.copyWith(secondPractice: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get thirdPractice {
    if (_self.thirdPractice == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.thirdPractice!, (value) {
    return _then(_self.copyWith(thirdPractice: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get qualifying {
    if (_self.qualifying == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.qualifying!, (value) {
    return _then(_self.copyWith(qualifying: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get sprintQualifying {
    if (_self.sprintQualifying == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.sprintQualifying!, (value) {
    return _then(_self.copyWith(sprintQualifying: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get sprint {
    if (_self.sprint == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.sprint!, (value) {
    return _then(_self.copyWith(sprint: value));
  });
}
}


/// Adds pattern-matching-related methods to [RacesModel].
extension RacesModelPatterns on RacesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RacesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RacesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RacesModel value)  $default,){
final _that = this;
switch (_that) {
case _RacesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RacesModel value)?  $default,){
final _that = this;
switch (_that) {
case _RacesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String season,  String round,  String url,  String raceName, @JsonKey(name: 'Circuit')  CircuitModel circuit,  String date,  String? time, @JsonKey(name: 'FirstPractice')  RaceDateModel? firstPractice, @JsonKey(name: 'SecondPractice')  RaceDateModel? secondPractice, @JsonKey(name: 'ThirdPractice')  RaceDateModel? thirdPractice, @JsonKey(name: 'Qualifying')  RaceDateModel? qualifying, @JsonKey(name: 'SprintQualifying')  RaceDateModel? sprintQualifying, @JsonKey(name: 'Sprint')  RaceDateModel? sprint, @JsonKey(name: 'Results')  List<ResultsModel>? results, @JsonKey(name: 'SprintResults')  List<ResultsModel>? sprintResults, @JsonKey(name: 'QualifyingResults')  List<QualifyingResultsModel>? qualifyingResults, @JsonKey(name: 'PitStops')  List<PitStopsModel>? pitStops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RacesModel() when $default != null:
return $default(_that.season,_that.round,_that.url,_that.raceName,_that.circuit,_that.date,_that.time,_that.firstPractice,_that.secondPractice,_that.thirdPractice,_that.qualifying,_that.sprintQualifying,_that.sprint,_that.results,_that.sprintResults,_that.qualifyingResults,_that.pitStops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String season,  String round,  String url,  String raceName, @JsonKey(name: 'Circuit')  CircuitModel circuit,  String date,  String? time, @JsonKey(name: 'FirstPractice')  RaceDateModel? firstPractice, @JsonKey(name: 'SecondPractice')  RaceDateModel? secondPractice, @JsonKey(name: 'ThirdPractice')  RaceDateModel? thirdPractice, @JsonKey(name: 'Qualifying')  RaceDateModel? qualifying, @JsonKey(name: 'SprintQualifying')  RaceDateModel? sprintQualifying, @JsonKey(name: 'Sprint')  RaceDateModel? sprint, @JsonKey(name: 'Results')  List<ResultsModel>? results, @JsonKey(name: 'SprintResults')  List<ResultsModel>? sprintResults, @JsonKey(name: 'QualifyingResults')  List<QualifyingResultsModel>? qualifyingResults, @JsonKey(name: 'PitStops')  List<PitStopsModel>? pitStops)  $default,) {final _that = this;
switch (_that) {
case _RacesModel():
return $default(_that.season,_that.round,_that.url,_that.raceName,_that.circuit,_that.date,_that.time,_that.firstPractice,_that.secondPractice,_that.thirdPractice,_that.qualifying,_that.sprintQualifying,_that.sprint,_that.results,_that.sprintResults,_that.qualifyingResults,_that.pitStops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String season,  String round,  String url,  String raceName, @JsonKey(name: 'Circuit')  CircuitModel circuit,  String date,  String? time, @JsonKey(name: 'FirstPractice')  RaceDateModel? firstPractice, @JsonKey(name: 'SecondPractice')  RaceDateModel? secondPractice, @JsonKey(name: 'ThirdPractice')  RaceDateModel? thirdPractice, @JsonKey(name: 'Qualifying')  RaceDateModel? qualifying, @JsonKey(name: 'SprintQualifying')  RaceDateModel? sprintQualifying, @JsonKey(name: 'Sprint')  RaceDateModel? sprint, @JsonKey(name: 'Results')  List<ResultsModel>? results, @JsonKey(name: 'SprintResults')  List<ResultsModel>? sprintResults, @JsonKey(name: 'QualifyingResults')  List<QualifyingResultsModel>? qualifyingResults, @JsonKey(name: 'PitStops')  List<PitStopsModel>? pitStops)?  $default,) {final _that = this;
switch (_that) {
case _RacesModel() when $default != null:
return $default(_that.season,_that.round,_that.url,_that.raceName,_that.circuit,_that.date,_that.time,_that.firstPractice,_that.secondPractice,_that.thirdPractice,_that.qualifying,_that.sprintQualifying,_that.sprint,_that.results,_that.sprintResults,_that.qualifyingResults,_that.pitStops);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RacesModel extends RacesModel {
  const _RacesModel({required this.season, required this.round, required this.url, required this.raceName, @JsonKey(name: 'Circuit') required this.circuit, required this.date, this.time, @JsonKey(name: 'FirstPractice') this.firstPractice, @JsonKey(name: 'SecondPractice') this.secondPractice, @JsonKey(name: 'ThirdPractice') this.thirdPractice, @JsonKey(name: 'Qualifying') this.qualifying, @JsonKey(name: 'SprintQualifying') this.sprintQualifying, @JsonKey(name: 'Sprint') this.sprint, @JsonKey(name: 'Results') final  List<ResultsModel>? results, @JsonKey(name: 'SprintResults') final  List<ResultsModel>? sprintResults, @JsonKey(name: 'QualifyingResults') final  List<QualifyingResultsModel>? qualifyingResults, @JsonKey(name: 'PitStops') final  List<PitStopsModel>? pitStops}): _results = results,_sprintResults = sprintResults,_qualifyingResults = qualifyingResults,_pitStops = pitStops,super._();
  factory _RacesModel.fromJson(Map<String, dynamic> json) => _$RacesModelFromJson(json);

@override final  String season;
@override final  String round;
@override final  String url;
@override final  String raceName;
@override@JsonKey(name: 'Circuit') final  CircuitModel circuit;
@override final  String date;
@override final  String? time;
@override@JsonKey(name: 'FirstPractice') final  RaceDateModel? firstPractice;
@override@JsonKey(name: 'SecondPractice') final  RaceDateModel? secondPractice;
@override@JsonKey(name: 'ThirdPractice') final  RaceDateModel? thirdPractice;
@override@JsonKey(name: 'Qualifying') final  RaceDateModel? qualifying;
/// Дата и время спринт-квалификации (сетка на спринт).
@override@JsonKey(name: 'SprintQualifying') final  RaceDateModel? sprintQualifying;
@override@JsonKey(name: 'Sprint') final  RaceDateModel? sprint;
 final  List<ResultsModel>? _results;
@override@JsonKey(name: 'Results') List<ResultsModel>? get results {
  final value = _results;
  if (value == null) return null;
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ResultsModel>? _sprintResults;
@override@JsonKey(name: 'SprintResults') List<ResultsModel>? get sprintResults {
  final value = _sprintResults;
  if (value == null) return null;
  if (_sprintResults is EqualUnmodifiableListView) return _sprintResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<QualifyingResultsModel>? _qualifyingResults;
@override@JsonKey(name: 'QualifyingResults') List<QualifyingResultsModel>? get qualifyingResults {
  final value = _qualifyingResults;
  if (value == null) return null;
  if (_qualifyingResults is EqualUnmodifiableListView) return _qualifyingResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<PitStopsModel>? _pitStops;
@override@JsonKey(name: 'PitStops') List<PitStopsModel>? get pitStops {
  final value = _pitStops;
  if (value == null) return null;
  if (_pitStops is EqualUnmodifiableListView) return _pitStops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RacesModelCopyWith<_RacesModel> get copyWith => __$RacesModelCopyWithImpl<_RacesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RacesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RacesModel&&(identical(other.season, season) || other.season == season)&&(identical(other.round, round) || other.round == round)&&(identical(other.url, url) || other.url == url)&&(identical(other.raceName, raceName) || other.raceName == raceName)&&(identical(other.circuit, circuit) || other.circuit == circuit)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.firstPractice, firstPractice) || other.firstPractice == firstPractice)&&(identical(other.secondPractice, secondPractice) || other.secondPractice == secondPractice)&&(identical(other.thirdPractice, thirdPractice) || other.thirdPractice == thirdPractice)&&(identical(other.qualifying, qualifying) || other.qualifying == qualifying)&&(identical(other.sprintQualifying, sprintQualifying) || other.sprintQualifying == sprintQualifying)&&(identical(other.sprint, sprint) || other.sprint == sprint)&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._sprintResults, _sprintResults)&&const DeepCollectionEquality().equals(other._qualifyingResults, _qualifyingResults)&&const DeepCollectionEquality().equals(other._pitStops, _pitStops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,round,url,raceName,circuit,date,time,firstPractice,secondPractice,thirdPractice,qualifying,sprintQualifying,sprint,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_sprintResults),const DeepCollectionEquality().hash(_qualifyingResults),const DeepCollectionEquality().hash(_pitStops));

@override
String toString() {
  return 'RacesModel(season: $season, round: $round, url: $url, raceName: $raceName, circuit: $circuit, date: $date, time: $time, firstPractice: $firstPractice, secondPractice: $secondPractice, thirdPractice: $thirdPractice, qualifying: $qualifying, sprintQualifying: $sprintQualifying, sprint: $sprint, results: $results, sprintResults: $sprintResults, qualifyingResults: $qualifyingResults, pitStops: $pitStops)';
}


}

/// @nodoc
abstract mixin class _$RacesModelCopyWith<$Res> implements $RacesModelCopyWith<$Res> {
  factory _$RacesModelCopyWith(_RacesModel value, $Res Function(_RacesModel) _then) = __$RacesModelCopyWithImpl;
@override @useResult
$Res call({
 String season, String round, String url, String raceName,@JsonKey(name: 'Circuit') CircuitModel circuit, String date, String? time,@JsonKey(name: 'FirstPractice') RaceDateModel? firstPractice,@JsonKey(name: 'SecondPractice') RaceDateModel? secondPractice,@JsonKey(name: 'ThirdPractice') RaceDateModel? thirdPractice,@JsonKey(name: 'Qualifying') RaceDateModel? qualifying,@JsonKey(name: 'SprintQualifying') RaceDateModel? sprintQualifying,@JsonKey(name: 'Sprint') RaceDateModel? sprint,@JsonKey(name: 'Results') List<ResultsModel>? results,@JsonKey(name: 'SprintResults') List<ResultsModel>? sprintResults,@JsonKey(name: 'QualifyingResults') List<QualifyingResultsModel>? qualifyingResults,@JsonKey(name: 'PitStops') List<PitStopsModel>? pitStops
});


@override $CircuitModelCopyWith<$Res> get circuit;@override $RaceDateModelCopyWith<$Res>? get firstPractice;@override $RaceDateModelCopyWith<$Res>? get secondPractice;@override $RaceDateModelCopyWith<$Res>? get thirdPractice;@override $RaceDateModelCopyWith<$Res>? get qualifying;@override $RaceDateModelCopyWith<$Res>? get sprintQualifying;@override $RaceDateModelCopyWith<$Res>? get sprint;

}
/// @nodoc
class __$RacesModelCopyWithImpl<$Res>
    implements _$RacesModelCopyWith<$Res> {
  __$RacesModelCopyWithImpl(this._self, this._then);

  final _RacesModel _self;
  final $Res Function(_RacesModel) _then;

/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? season = null,Object? round = null,Object? url = null,Object? raceName = null,Object? circuit = null,Object? date = null,Object? time = freezed,Object? firstPractice = freezed,Object? secondPractice = freezed,Object? thirdPractice = freezed,Object? qualifying = freezed,Object? sprintQualifying = freezed,Object? sprint = freezed,Object? results = freezed,Object? sprintResults = freezed,Object? qualifyingResults = freezed,Object? pitStops = freezed,}) {
  return _then(_RacesModel(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,raceName: null == raceName ? _self.raceName : raceName // ignore: cast_nullable_to_non_nullable
as String,circuit: null == circuit ? _self.circuit : circuit // ignore: cast_nullable_to_non_nullable
as CircuitModel,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,firstPractice: freezed == firstPractice ? _self.firstPractice : firstPractice // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,secondPractice: freezed == secondPractice ? _self.secondPractice : secondPractice // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,thirdPractice: freezed == thirdPractice ? _self.thirdPractice : thirdPractice // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,qualifying: freezed == qualifying ? _self.qualifying : qualifying // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,sprintQualifying: freezed == sprintQualifying ? _self.sprintQualifying : sprintQualifying // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,sprint: freezed == sprint ? _self.sprint : sprint // ignore: cast_nullable_to_non_nullable
as RaceDateModel?,results: freezed == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ResultsModel>?,sprintResults: freezed == sprintResults ? _self._sprintResults : sprintResults // ignore: cast_nullable_to_non_nullable
as List<ResultsModel>?,qualifyingResults: freezed == qualifyingResults ? _self._qualifyingResults : qualifyingResults // ignore: cast_nullable_to_non_nullable
as List<QualifyingResultsModel>?,pitStops: freezed == pitStops ? _self._pitStops : pitStops // ignore: cast_nullable_to_non_nullable
as List<PitStopsModel>?,
  ));
}

/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CircuitModelCopyWith<$Res> get circuit {
  
  return $CircuitModelCopyWith<$Res>(_self.circuit, (value) {
    return _then(_self.copyWith(circuit: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get firstPractice {
    if (_self.firstPractice == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.firstPractice!, (value) {
    return _then(_self.copyWith(firstPractice: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get secondPractice {
    if (_self.secondPractice == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.secondPractice!, (value) {
    return _then(_self.copyWith(secondPractice: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get thirdPractice {
    if (_self.thirdPractice == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.thirdPractice!, (value) {
    return _then(_self.copyWith(thirdPractice: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get qualifying {
    if (_self.qualifying == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.qualifying!, (value) {
    return _then(_self.copyWith(qualifying: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get sprintQualifying {
    if (_self.sprintQualifying == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.sprintQualifying!, (value) {
    return _then(_self.copyWith(sprintQualifying: value));
  });
}/// Create a copy of RacesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RaceDateModelCopyWith<$Res>? get sprint {
    if (_self.sprint == null) {
    return null;
  }

  return $RaceDateModelCopyWith<$Res>(_self.sprint!, (value) {
    return _then(_self.copyWith(sprint: value));
  });
}
}

// dart format on
