// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_table_model.g.dart';

@JsonSerializable()
class DriverTableModel {
  final String driverId;
  final List<DriverModel> Drivers;

  DriverTableModel({
    required this.Drivers,
    required this.driverId,
  });

  factory DriverTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverTableModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('DriverTableModel: $e'),
        StackTrace.current,
      );
    }
  }
}
