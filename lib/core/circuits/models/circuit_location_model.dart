import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circuit_location_model.freezed.dart';
part 'circuit_location_model.g.dart';

/// Модель географического расположения трассы.
@Freezed(fromJson: true, toJson: true)
abstract class CircuitLocationModel with _$CircuitLocationModel {
  const factory CircuitLocationModel({
    required String lat,
    required String long,
    required String locality,
    required String country,
  }) = _CircuitLocationModel;

  /// Создаёт модель из JSON-ответа API.
  factory CircuitLocationModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitLocationModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('CircuitLocationModel: $e'), StackTrace.current);
    }
  }
}
