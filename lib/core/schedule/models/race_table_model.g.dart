// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RaceTableModel _$RaceTableModelFromJson(Map<String, dynamic> json) =>
    _RaceTableModel(
      season: json['season'] as String? ?? '',
      races: (json['Races'] as List<dynamic>)
          .map((e) => RacesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      round: json['round'] as String?,
    );

Map<String, dynamic> _$RaceTableModelToJson(_RaceTableModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'Races': instance.races,
      'round': instance.round,
    };
