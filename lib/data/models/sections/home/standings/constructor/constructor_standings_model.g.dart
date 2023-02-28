// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constructor_standings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConstructorStandingsModel _$ConstructorStandingsModelFromJson(
        Map<String, dynamic> json) =>
    ConstructorStandingsModel(
      position: json['position'] as String,
      positionText: json['positionText'] as String,
      points: json['points'] as String,
      wins: json['wins'] as String,
      Constructor: ConstructorModel.fromJson(
          json['Constructor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConstructorStandingsModelToJson(
        ConstructorStandingsModel instance) =>
    <String, dynamic>{
      'position': instance.position,
      'positionText': instance.positionText,
      'points': instance.points,
      'wins': instance.wins,
      'Constructor': instance.Constructor,
    };
