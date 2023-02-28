// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_standings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverStandingsModel _$DriverStandingsModelFromJson(
        Map<String, dynamic> json) =>
    DriverStandingsModel(
      Constructors: (json['Constructors'] as List<dynamic>)
          .map((e) => ConstructorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      Driver: DriverModel.fromJson(json['Driver'] as Map<String, dynamic>),
      points: json['points'] as String,
      wins: json['wins'] as String,
      positionText: json['positionText'] as String,
      position: json['position'] as String,
    );

Map<String, dynamic> _$DriverStandingsModelToJson(
        DriverStandingsModel instance) =>
    <String, dynamic>{
      'position': instance.position,
      'positionText': instance.positionText,
      'points': instance.points,
      'wins': instance.wins,
      'Driver': instance.Driver,
      'Constructors': instance.Constructors,
    };
