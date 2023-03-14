// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/results/driver/driver_table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_fetching_model.g.dart';

@JsonSerializable()
class DriverFetchingModel {
  final DriverTableModel DriverTable;

  DriverFetchingModel({
    required this.DriverTable,
  });

  factory DriverFetchingModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverFetchingModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('DriverFetchingModel: $e');
    }
  }
}
