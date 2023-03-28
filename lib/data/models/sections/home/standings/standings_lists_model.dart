// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_lists_model.g.dart';

@JsonSerializable()
class StandingsListsModel {
  final String season;
  final String round;
  final List<ConstructorStandingsModel>? ConstructorStandings;
  final List<DriverStandingsModel>? DriverStandings;

  StandingsListsModel({
    required this.season,
    required this.round,
    required this.ConstructorStandings,
    required this.DriverStandings,
  });

  factory StandingsListsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsListsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('StandingsListsModel: $e'),
        StackTrace.current,
      );
    }
  }
}
