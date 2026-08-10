// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircuitModel _$CircuitModelFromJson(Map<String, dynamic> json) =>
    _CircuitModel(
      circuitId: json['circuitId'] as String,
      url: json['url'] as String,
      circuitName: json['circuitName'] as String,
      location: CircuitLocationModel.fromJson(
        json['Location'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CircuitModelToJson(_CircuitModel instance) =>
    <String, dynamic>{
      'circuitId': instance.circuitId,
      'url': instance.url,
      'circuitName': instance.circuitName,
      'Location': instance.location,
    };
