import 'package:f1_pet_project/core/circuits/models/circuit_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circuits_model.freezed.dart';
part 'circuits_model.g.dart';

/// Корневая модель ответа API со списком трасс.
@Freezed(fromJson: true, toJson: true)
abstract class CircuitsModel with _$CircuitsModel {
  const factory CircuitsModel({
    @JsonKey(name: 'CircuitTable') required CircuitTableModel circuitTable,
  }) = _CircuitsModel;

  /// Создаёт модель из JSON-ответа API.
  factory CircuitsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('CircuitsModel: $e'), StackTrace.current);
    }
  }
}
