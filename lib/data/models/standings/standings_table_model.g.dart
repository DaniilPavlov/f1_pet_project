// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standings_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StandingsTableModel _$StandingsTableModelFromJson(Map<String, dynamic> json) =>
    _StandingsTableModel(
      standingsLists: (json['StandingsLists'] as List<dynamic>)
          .map((e) => StandingsListsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StandingsTableModelToJson(
  _StandingsTableModel instance,
) => <String, dynamic>{'StandingsLists': instance.standingsLists};
