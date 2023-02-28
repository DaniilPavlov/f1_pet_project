// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_model.g.dart';

@JsonSerializable()
class StandingsModel {
  final StandingsTableModel StandingsTable;

  StandingsModel({
    required this.StandingsTable,
  });

  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('StandingsModel: $e');
    }
  }
}
