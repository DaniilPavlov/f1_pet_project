// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standings_lists_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandingsListsModel _$StandingsListsModelFromJson(Map<String, dynamic> json) =>
    StandingsListsModel(
      season: json['season'] as String,
      round: json['round'] as String,
      ConstructorStandings: (json['ConstructorStandings'] as List<dynamic>?)
          ?.map((e) =>
              ConstructorStandingsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      DriverStandings: (json['DriverStandings'] as List<dynamic>?)
          ?.map((e) => DriverStandingsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StandingsListsModelToJson(
        StandingsListsModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'round': instance.round,
      'ConstructorStandings': instance.ConstructorStandings,
      'DriverStandings': instance.DriverStandings,
    };
