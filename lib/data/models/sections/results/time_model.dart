import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_model.g.dart';

@JsonSerializable()
class TimeModel {
  final String? millis;
  final String time;

  TimeModel({
    required this.millis,
    required this.time,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$TimeModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('TimeModel: $e');
    }
  }
}

