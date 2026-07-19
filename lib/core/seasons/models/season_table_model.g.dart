// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonTableModel _$SeasonTableModelFromJson(Map<String, dynamic> json) =>
    SeasonTableModel(
      seasons: (json['Seasons'] as List<dynamic>)
          .map((e) => SeasonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeasonTableModelToJson(SeasonTableModel instance) =>
    <String, dynamic>{'Seasons': instance.seasons};
