// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircuitLocationModel _$CircuitLocationModelFromJson(
  Map<String, dynamic> json,
) => CircuitLocationModel(
  lat: json['lat'] as String,
  long: json['long'] as String,
  locality: json['locality'] as String,
  country: json['country'] as String,
);

Map<String, dynamic> _$CircuitLocationModelToJson(
  CircuitLocationModel instance,
) => <String, dynamic>{
  'lat': instance.lat,
  'long': instance.long,
  'locality': instance.locality,
  'country': instance.country,
};
