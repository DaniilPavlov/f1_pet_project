// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standings_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandingsTableModel _$StandingsTableModelFromJson(Map<String, dynamic> json) =>
    StandingsTableModel(
      season: json['season'] as String,
      StandingsLists: (json['StandingsLists'] as List<dynamic>)
          .map((e) => StandingsListsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StandingsTableModelToJson(
        StandingsTableModel instance) =>
    <String, dynamic>{
      'season': instance.season,
      'StandingsLists': instance.StandingsLists,
    };
