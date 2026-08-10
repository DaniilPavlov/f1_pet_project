// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_standings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverStandingsModel _$DriverStandingsModelFromJson(
  Map<String, dynamic> json,
) => _DriverStandingsModel(
  position: json['position'] as String? ?? '',
  positionText: json['positionText'] as String? ?? '',
  points: json['points'] as String? ?? '0',
  wins: json['wins'] as String? ?? '0',
  driver: DriverModel.fromJson(json['Driver'] as Map<String, dynamic>),
  constructors:
      (json['Constructors'] as List<dynamic>?)
          ?.map((e) => ConstructorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$DriverStandingsModelToJson(
  _DriverStandingsModel instance,
) => <String, dynamic>{
  'position': instance.position,
  'positionText': instance.positionText,
  'points': instance.points,
  'wins': instance.wins,
  'Driver': instance.driver,
  'Constructors': instance.constructors,
};
