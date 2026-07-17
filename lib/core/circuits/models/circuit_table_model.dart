import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circuit_table_model.g.dart';

/// Таблица трасс из ответа API.
@JsonSerializable()
class CircuitTableModel {
  CircuitTableModel({required this.circuits});

  /// Создаёт модель из JSON-ответа API.
  factory CircuitTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('CircuitTableModel: $e'), StackTrace.current);
    }
  }
  @JsonKey(name: 'Circuits')
  final List<CircuitModel> circuits;
}
