// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaceTableModel _$RaceTableModelFromJson(Map<String, dynamic> json) =>
    RaceTableModel(
      Races: (json['Races'] as List<dynamic>)
          .map((e) => RacesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      season: json['season'] as String,
    );

Map<String, dynamic> _$RaceTableModelToJson(RaceTableModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'Races': instance.Races,
    };
