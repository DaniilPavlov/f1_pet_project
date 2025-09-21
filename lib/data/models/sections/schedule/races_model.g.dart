// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'races_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RacesModel _$RacesModelFromJson(Map<String, dynamic> json) => RacesModel(
  season: json['season'] as String,
  round: json['round'] as String,
  url: json['url'] as String,
  raceName: json['raceName'] as String,
  circuit: CircuitModel.fromJson(json['Circuit'] as Map<String, dynamic>),
  date: json['date'] as String,
  time: json['time'] as String?,
  firstPractice: json['FirstPractice'] == null
      ? null
      : RaceDateModel.fromJson(json['FirstPractice'] as Map<String, dynamic>),
  secondPractice: json['SecondPractice'] == null
      ? null
      : RaceDateModel.fromJson(json['SecondPractice'] as Map<String, dynamic>),
  thirdPractice: json['ThirdPractice'] == null
      ? null
      : RaceDateModel.fromJson(json['ThirdPractice'] as Map<String, dynamic>),
  qualifying: json['Qualifying'] == null
      ? null
      : RaceDateModel.fromJson(json['Qualifying'] as Map<String, dynamic>),
  sprint: json['Sprint'] == null
      ? null
      : RaceDateModel.fromJson(json['Sprint'] as Map<String, dynamic>),
  results: (json['Results'] as List<dynamic>?)
      ?.map((e) => ResultsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  qualifyingResults: (json['QualifyingResults'] as List<dynamic>?)
      ?.map((e) => QualifyingResultsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pitStops: (json['PitStops'] as List<dynamic>?)
      ?.map((e) => PitStopsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RacesModelToJson(RacesModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'round': instance.round,
      'url': instance.url,
      'raceName': instance.raceName,
      'Circuit': instance.circuit,
      'date': instance.date,
      'time': instance.time,
      'FirstPractice': instance.firstPractice,
      'SecondPractice': instance.secondPractice,
      'ThirdPractice': instance.thirdPractice,
      'Qualifying': instance.qualifying,
      'Sprint': instance.sprint,
      'Results': instance.results,
      'QualifyingResults': instance.qualifyingResults,
      'PitStops': instance.pitStops,
    };
