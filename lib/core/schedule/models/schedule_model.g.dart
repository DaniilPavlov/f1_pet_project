// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      raceTable: RaceTableModel.fromJson(
        json['RaceTable'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{'RaceTable': instance.raceTable};
