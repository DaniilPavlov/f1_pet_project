// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circuit_model.g.dart';

@JsonSerializable()
class CircuitModel {
  final String circuitId;
  final String url;
  final String circuitName;
  final CircuitLocationModel Location;

  CircuitModel({
    required this.circuitId,
    required this.url,
    required this.circuitName,
    required this.Location,
  });

  factory CircuitModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('CircuitModel: $e');
    }
  }
}
