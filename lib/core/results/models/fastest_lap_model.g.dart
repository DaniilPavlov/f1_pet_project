// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fastest_lap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FastestLapModel _$FastestLapModelFromJson(Map<String, dynamic> json) =>
    FastestLapModel(
      averageSpeed: json['AverageSpeed'] == null
          ? null
          : AverageSpeedModel.fromJson(
              json['AverageSpeed'] as Map<String, dynamic>,
            ),
      time: TimeModel.fromJson(json['Time'] as Map<String, dynamic>),
      lap: json['lap'] as String,
      rank: json['rank'] as String,
    );

Map<String, dynamic> _$FastestLapModelToJson(FastestLapModel instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'lap': instance.lap,
      'Time': instance.time,
      'AverageSpeed': instance.averageSpeed,
    };
