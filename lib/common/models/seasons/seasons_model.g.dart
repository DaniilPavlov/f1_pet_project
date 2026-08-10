// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasons_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeasonsModel _$SeasonsModelFromJson(Map<String, dynamic> json) =>
    _SeasonsModel(
      seasonTable: SeasonTableModel.fromJson(
        json['SeasonTable'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SeasonsModelToJson(_SeasonsModel instance) =>
    <String, dynamic>{'SeasonTable': instance.seasonTable};
