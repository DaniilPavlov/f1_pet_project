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
      Driver: DriverModel.fromJson(json['Driver'] as Map<String, dynamic>),
      Constructor: ConstructorModel.fromJson(
          json['Constructor'] as Map<String, dynamic>),
      Q1: json['Q1'] as String,
      Q2: json['Q2'] as String?,
      Q3: json['Q3'] as String?,
    );

Map<String, dynamic> _$QualifyingResultsModelToJson(
        QualifyingResultsModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'position': instance.position,
      'Driver': instance.Driver,
      'Constructor': instance.Constructor,
      'Q1': instance.Q1,
      'Q2': instance.Q2,
      'Q3': instance.Q3,
    };
