// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_standings_model.g.dart';

@JsonSerializable()
class DriverStandingsModel {
  final String position;
  final String positionText;
  final String points;
  final String wins;
  final DriverModel Driver;
  final List<ConstructorModel> Constructors;

  DriverStandingsModel({
    required this.Constructors,
    required this.Driver,
    required this.points,
    required this.wins,
    required this.positionText,
    required this.position,
  });

  factory DriverStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverStandingsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('DriverStandingsModel: $e'),
        StackTrace.current,
      );
    }
  }
}
