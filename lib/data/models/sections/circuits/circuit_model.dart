import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circuit_model.g.dart';

@JsonSerializable()
class CircuitModel {
  CircuitModel({
    required this.circuitId,
    required this.url,
    required this.circuitName,
    required this.location,
  });

  factory CircuitModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('CircuitModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String circuitId;
  final String url;
  final String circuitName;
  @JsonKey(name: 'Location')
  final CircuitLocationModel location;
}
