import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_standings_model.g.dart';

@JsonSerializable()
class DriverStandingsModel {
  DriverStandingsModel({
    required this.constructors,
    required this.driver,
    required this.points,
    required this.wins,
    required this.positionText,
    required this.position,
  });

  factory DriverStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverStandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('DriverStandingsModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String position;
  final String positionText;
  final String points;
  final String wins;
  @JsonKey(name: 'Driver')
  final DriverModel driver;
  @JsonKey(name: 'Constructors')
  final List<ConstructorModel> constructors;
}
