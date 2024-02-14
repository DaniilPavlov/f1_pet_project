import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circuits_model.g.dart';

@JsonSerializable()
class CircuitsModel {
  CircuitsModel({required this.circuitTable});

  factory CircuitsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CircuitsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('CircuitsModel: $e'),
        StackTrace.current,
      );
    }
  }
  @JsonKey(name: 'CircuitTable')
  final CircuitTableModel circuitTable;
}
