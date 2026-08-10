import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circuit_table_model.freezed.dart';
part 'circuit_table_model.g.dart';

/// Таблица трасс из ответа API.
@Freezed(fromJson: true, toJson: true)
abstract class CircuitTableModel with _$CircuitTableModel {
  const factory CircuitTableModel({
    @JsonKey(name: 'Circuits') required List<CircuitModel> circuits,
  }) = _CircuitTableModel;

  /// Создаёт модель из JSON-ответа API.
  factory CircuitTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('CircuitTableModel: $e'), StackTrace.current);
    }
  }
}
