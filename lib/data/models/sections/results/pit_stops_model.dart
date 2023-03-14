// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pit_stops_model.g.dart';

@JsonSerializable()
class PitStopsModel {
  final String driverId;
  final String lap;
  final String stop;
  final String time;
  final String duration;

  PitStopsModel({
    required this.driverId,
    required this.lap,
    required this.stop,
    required this.time,
    required this.duration,
  });

  factory PitStopsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$PitStopsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('PitStopsModel: $e');
    }
  }
}
