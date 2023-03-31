// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'race_date_model.g.dart';

@JsonSerializable()
class RaceDateModel {
  final String date;
  final String time;

  RaceDateModel({
    required this.date,
    required this.time,
  });

  factory RaceDateModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceDateModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('RaceDateModel: $e'),
        StackTrace.current,
      );
    }
  }
}
