// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'race_table_model.g.dart';

@JsonSerializable()
class RaceTableModel {
  final String season;
  final List<RacesModel> Races;

  RaceTableModel({
    required this.Races,
    required this.season,
  });

  factory RaceTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceTableModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('RaceTableModel: $e');
    }
  }
}
