// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultsModel _$ResultsModelFromJson(Map<String, dynamic> json) => ResultsModel(
  number: json['number'] as String,
  position: json['position'] as String,
  positionText: json['positionText'] as String,
  points: json['points'] as String,
  driver: DriverModel.fromJson(json['Driver'] as Map<String, dynamic>),
  constructor: ConstructorModel.fromJson(
    json['Constructor'] as Map<String, dynamic>,
  ),
  grid: json['grid'] as String,
  laps: json['laps'] as String,
  status: json['status'] as String,
  time: json['Time'] == null
      ? null
      : TimeModel.fromJson(json['Time'] as Map<String, dynamic>),
  fastestLap: json['FastestLap'] == null
      ? null
      : FastestLapModel.fromJson(json['FastestLap'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResultsModelToJson(ResultsModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'position': instance.position,
      'positionText': instance.positionText,
      'points': instance.points,
      'Driver': instance.driver,
      'Constructor': instance.constructor,
      'grid': instance.grid,
      'laps': instance.laps,
      'status': instance.status,
      'Time': instance.time,
      'FastestLap': instance.fastestLap,
    };
