// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverTableModel _$DriverTableModelFromJson(Map<String, dynamic> json) =>
    _DriverTableModel(
      driverId: json['driverId'] as String,
      drivers: (json['Drivers'] as List<dynamic>)
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DriverTableModelToJson(_DriverTableModel instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'Drivers': instance.drivers,
    };
