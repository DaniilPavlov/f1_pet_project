// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/results/average_speed_model.dart';
import 'package:f1_pet_project/data/models/sections/results/time_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fastest_lap_model.g.dart';

@JsonSerializable()
class FastestLapModel {
  final String rank;
  final String lap;
  final TimeModel Time;
  final AverageSpeedModel AverageSpeed;

  FastestLapModel({
    required this.AverageSpeed,
    required this.Time,
    required this.lap,
    required this.rank,
  });

  factory FastestLapModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$FastestLapModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('FastestLapModel: $e'),
        StackTrace.current,
      );
    }
  }
}
