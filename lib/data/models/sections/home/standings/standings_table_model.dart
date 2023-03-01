// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_table_model.g.dart';

@JsonSerializable()
class StandingsTableModel {
  final List<StandingsListsModel> StandingsLists;

  StandingsTableModel({
    required this.StandingsLists,
  });

  factory StandingsTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsTableModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('StandingsTableModel: $e');
    }
  }
}
