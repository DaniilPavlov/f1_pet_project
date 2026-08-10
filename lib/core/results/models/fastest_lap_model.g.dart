// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fastest_lap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FastestLapModel _$FastestLapModelFromJson(Map<String, dynamic> json) =>
    _FastestLapModel(
      rank: json['rank'] as String,
      lap: json['lap'] as String,
      time: TimeModel.fromJson(json['Time'] as Map<String, dynamic>),
      averageSpeed: json['AverageSpeed'] == null
          ? null
          : AverageSpeedModel.fromJson(
              json['AverageSpeed'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$FastestLapModelToJson(_FastestLapModel instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'lap': instance.lap,
      'Time': instance.time,
      'AverageSpeed': instance.averageSpeed,
    };
