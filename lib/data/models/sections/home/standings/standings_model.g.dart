// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandingsModel _$StandingsModelFromJson(Map<String, dynamic> json) =>
    StandingsModel(
      StandingsTable: StandingsTableModel.fromJson(
          json['StandingsTable'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StandingsModelToJson(StandingsModel instance) =>
    <String, dynamic>{
      'StandingsTable': instance.StandingsTable,
    };
