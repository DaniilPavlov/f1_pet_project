// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualifying_results_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QualifyingResultsModel _$QualifyingResultsModelFromJson(
        Map<String, dynamic> json) =>
    QualifyingResultsModel(
      number: json['number'] as String,
      position: json['position'] as String,
      driver: DriverModel.fromJson(json['Driver'] as Map<String, dynamic>),
      constructor: ConstructorModel.fromJson(
          json['Constructor'] as Map<String, dynamic>),
      q1: json['Q1'] as String,
      q2: json['Q2'] as String?,
      q3: json['Q3'] as String?,
    );

Map<String, dynamic> _$QualifyingResultsModelToJson(
        QualifyingResultsModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'position': instance.position,
      'Driver': instance.driver,
      'Constructor': instance.constructor,
      'Q1': instance.q1,
      'Q2': instance.q2,
      'Q3': instance.q3,
    };
