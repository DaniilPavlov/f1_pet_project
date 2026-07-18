import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_model.g.dart';

/// Время финиша или круга в миллисекундах и строковом виде.
@JsonSerializable()
class TimeModel {
  TimeModel({required this.millis, required this.time});

  /// Создаёт модель из JSON ответа API.
  factory TimeModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$TimeModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('TimeModel: $e'), StackTrace.current);
    }
  }
  final String? millis;
  final String time;
}
