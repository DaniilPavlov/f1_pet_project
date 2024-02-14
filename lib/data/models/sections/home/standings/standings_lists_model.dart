import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_lists_model.g.dart';

@JsonSerializable()
class StandingsListsModel {
  StandingsListsModel({
    required this.season,
    required this.round,
    required this.constructorStandings,
    required this.driverStandings,
  });

  factory StandingsListsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsListsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('StandingsListsModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String season;
  final String round;
  @JsonKey(name: 'ConstructorStandings')
  final List<ConstructorStandingsModel>? constructorStandings;
  @JsonKey(name: 'DriverStandings')
  final List<DriverStandingsModel>? driverStandings;
}
