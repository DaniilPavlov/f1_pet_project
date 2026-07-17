import 'package:f1_pet_project/core/results/models/driver/driver_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_fetching_model.g.dart';

/// Обёртка ответа API с данными пилота.
@JsonSerializable()
class DriverFetchingModel {
  DriverFetchingModel({required this.driverTable});

  /// Создаёт модель из JSON ответа API.
  factory DriverFetchingModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverFetchingModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('DriverFetchingModel: $e'), StackTrace.current);
    }
  }
  @JsonKey(name: 'DriverTable')
  final DriverTableModel driverTable;
}
