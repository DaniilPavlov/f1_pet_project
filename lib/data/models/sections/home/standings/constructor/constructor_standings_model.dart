// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constructor_standings_model.g.dart';

@JsonSerializable()
class ConstructorStandingsModel {
  final String position;
  final String positionText;
  final String points;
  final String wins;
  final ConstructorModel Constructor;

  ConstructorStandingsModel({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.Constructor,
  });

  factory ConstructorStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorStandingsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('ConstructorStandingsModel: $e'),
        StackTrace.current,
      );
    }
  }
}
