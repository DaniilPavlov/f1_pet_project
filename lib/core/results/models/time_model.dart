import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_model.freezed.dart';
part 'time_model.g.dart';

/// Время финиша или круга в миллисекундах и строковом виде.
@Freezed(fromJson: true, toJson: true)
abstract class TimeModel with _$TimeModel {
  const factory TimeModel({required String? millis, required String time}) = _TimeModel;

  /// Создаёт модель из JSON ответа API.
  factory TimeModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$TimeModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('TimeModel: $e'), StackTrace.current);
    }
  }
}
