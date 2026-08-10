import 'package:f1_pet_project/core/circuits/models/circuit_location_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circuit_model.freezed.dart';
part 'circuit_model.g.dart';

/// Модель трассы Формулы-1.
@Freezed(fromJson: true, toJson: true)
abstract class CircuitModel with _$CircuitModel {
  const factory CircuitModel({
    required String circuitId,
    required String url,
    required String circuitName,
    @JsonKey(name: 'Location') required CircuitLocationModel location,
  }) = _CircuitModel;

  /// Создаёт модель из JSON-ответа API.
  factory CircuitModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('CircuitModel: $e'), StackTrace.current);
    }
  }
}
