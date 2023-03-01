// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/schedule/race_table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  final RaceTableModel RaceTable;

  ScheduleModel({
    required this.RaceTable,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ScheduleModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('ScheduleModel: $e');
    }
  }
}
