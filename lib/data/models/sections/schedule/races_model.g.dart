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
      Circuit: CircuitModel.fromJson(json['Circuit'] as Map<String, dynamic>),
      date: json['date'] as String,
      time: json['time'] as String,
      FirstPractice: json['FirstPractice'] == null
          ? null
          : RaceDateModel.fromJson(
              json['FirstPractice'] as Map<String, dynamic>),
      SecondPractice: json['SecondPractice'] == null
          ? null
          : RaceDateModel.fromJson(
              json['SecondPractice'] as Map<String, dynamic>),
      ThirdPractice: json['ThirdPractice'] == null
          ? null
          : RaceDateModel.fromJson(
              json['ThirdPractice'] as Map<String, dynamic>),
      Qualifying: json['Qualifying'] == null
          ? null
          : RaceDateModel.fromJson(json['Qualifying'] as Map<String, dynamic>),
      Sprint: json['Sprint'] == null
          ? null
          : RaceDateModel.fromJson(json['Sprint'] as Map<String, dynamic>),
      Results: (json['Results'] as List<dynamic>?)
          ?.map((e) => ResultsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RacesModelToJson(RacesModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'round': instance.round,
      'url': instance.url,
      'raceName': instance.raceName,
      'Circuit': instance.Circuit,
      'date': instance.date,
      'time': instance.time,
      'FirstPractice': instance.FirstPractice,
      'SecondPractice': instance.SecondPractice,
      'ThirdPractice': instance.ThirdPractice,
      'Qualifying': instance.Qualifying,
      'Sprint': instance.Sprint,
      'Results': instance.Results,
    };
