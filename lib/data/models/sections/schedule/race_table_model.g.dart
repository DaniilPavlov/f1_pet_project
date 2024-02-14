// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaceTableModel _$RaceTableModelFromJson(Map<String, dynamic> json) =>
    RaceTableModel(
      races: (json['Races'] as List<dynamic>)
          .map((e) => RacesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      season: json['season'] as String,
      round: json['round'] as String?,
    );

Map<String, dynamic> _$RaceTableModelToJson(RaceTableModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'round': instance.round,
      'Races': instance.races,
    };
