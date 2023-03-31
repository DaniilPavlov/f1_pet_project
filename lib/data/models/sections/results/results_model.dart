// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/sections/results/fastest_lap_model.dart';
import 'package:f1_pet_project/data/models/sections/results/time_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results_model.g.dart';

@JsonSerializable()
class ResultsModel {
  final String number;
  final String position;
  final String positionText;
  final String points;
  final DriverModel Driver;
  final ConstructorModel Constructor;
  final String grid;
  final String laps;
  final String status;
  final TimeModel? Time;
  final FastestLapModel? FastestLap;

  ResultsModel({
    required this.number,
    required this.position,
    required this.positionText,
    required this.points,
    required this.Driver,
    required this.Constructor,
    required this.grid,
    required this.laps,
    required this.status,
    required this.Time,
    required this.FastestLap,
  });

  factory ResultsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ResultsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('ResultsModel: $e'),
        StackTrace.current,
      );
    }
  }
}
