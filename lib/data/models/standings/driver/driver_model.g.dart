// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => _DriverModel(
  driverId: json['driverId'] as String,
  url: json['url'] as String? ?? '',
  givenName: json['givenName'] as String,
  familyName: json['familyName'] as String,
  dateOfBirth: json['dateOfBirth'] as String? ?? '',
  nationality: json['nationality'] as String? ?? '',
  permanentNumber: json['permanentNumber'] as String?,
  code: json['code'] as String?,
);

Map<String, dynamic> _$DriverModelToJson(_DriverModel instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'url': instance.url,
      'givenName': instance.givenName,
      'familyName': instance.familyName,
      'dateOfBirth': instance.dateOfBirth,
      'nationality': instance.nationality,
      'permanentNumber': instance.permanentNumber,
      'code': instance.code,
    };
