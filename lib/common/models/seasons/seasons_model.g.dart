// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasons_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonsModel _$SeasonsModelFromJson(Map<String, dynamic> json) => SeasonsModel(
  seasonTable: SeasonTableModel.fromJson(
    json['SeasonTable'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SeasonsModelToJson(SeasonsModel instance) =>
    <String, dynamic>{'SeasonTable': instance.seasonTable};
