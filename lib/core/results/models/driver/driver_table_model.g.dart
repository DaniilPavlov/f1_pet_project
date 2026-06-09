// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverTableModel _$DriverTableModelFromJson(Map<String, dynamic> json) =>
    DriverTableModel(
      drivers: (json['Drivers'] as List<dynamic>)
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      driverId: json['driverId'] as String,
    );

Map<String, dynamic> _$DriverTableModelToJson(DriverTableModel instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'Drivers': instance.drivers,
    };
