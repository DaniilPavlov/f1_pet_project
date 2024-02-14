import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/sections/results/fastest_lap_model.dart';
import 'package:f1_pet_project/data/models/sections/results/time_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results_model.g.dart';

@JsonSerializable()
class ResultsModel {
  ResultsModel({
    required this.number,
    required this.position,
    required this.positionText,
    required this.points,
    required this.driver,
    required this.constructor,
    required this.grid,
    required this.laps,
    required this.status,
    required this.time,
    required this.fastestLap,
  });

  factory ResultsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ResultsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('ResultsModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String number;
  final String position;
  final String positionText;
  final String points;
  @JsonKey(name: 'Driver')
  final DriverModel driver;
  @JsonKey(name: 'Constructor')
  final ConstructorModel constructor;
  final String grid;
  final String laps;
  final String status;
  @JsonKey(name: 'Time')
  final TimeModel? time;
  @JsonKey(name: 'FastestLap')
  final FastestLapModel? fastestLap;
}
