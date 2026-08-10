// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StandingsModel _$StandingsModelFromJson(Map<String, dynamic> json) =>
    _StandingsModel(
      standingsTable: StandingsTableModel.fromJson(
        json['StandingsTable'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$StandingsModelToJson(_StandingsModel instance) =>
    <String, dynamic>{'StandingsTable': instance.standingsTable};
