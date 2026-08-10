// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeasonTableModel _$SeasonTableModelFromJson(Map<String, dynamic> json) =>
    _SeasonTableModel(
      seasons: (json['Seasons'] as List<dynamic>)
          .map((e) => SeasonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeasonTableModelToJson(_SeasonTableModel instance) =>
    <String, dynamic>{'Seasons': instance.seasons};
