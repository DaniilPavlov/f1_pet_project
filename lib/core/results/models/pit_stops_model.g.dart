// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pit_stops_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PitStopsModel _$PitStopsModelFromJson(Map<String, dynamic> json) =>
    _PitStopsModel(
      driverId: json['driverId'] as String,
      lap: json['lap'] as String,
      stop: json['stop'] as String,
      time: json['time'] as String,
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$PitStopsModelToJson(_PitStopsModel instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'lap': instance.lap,
      'stop': instance.stop,
      'time': instance.time,
      'duration': instance.duration,
    };
