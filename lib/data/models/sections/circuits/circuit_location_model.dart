import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circuit_location_model.g.dart';

@JsonSerializable()
class CircuitLocationModel {
  final String lat;
  final String long;
  final String locality;
  final String country;

  CircuitLocationModel({
    required this.lat,
    required this.long,
    required this.locality,
    required this.country,
  });

  factory CircuitLocationModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitLocationModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('CircuitLocationModel: $e');
    }
  }
}
