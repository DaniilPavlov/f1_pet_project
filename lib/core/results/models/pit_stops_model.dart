import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pit_stops_model.freezed.dart';
part 'pit_stops_model.g.dart';

/// Данные одного пит-стопа пилота в гонке.
@Freezed(fromJson: true, toJson: true)
abstract class PitStopsModel with _$PitStopsModel {
  const factory PitStopsModel({
    required String driverId,
    required String lap,
    required String stop,
    required String time,
    required String duration,
  }) = _PitStopsModel;

  /// Создаёт модель из JSON ответа API.
  factory PitStopsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$PitStopsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('PitStopsModel: $e'), StackTrace.current);
    }
  }
}
