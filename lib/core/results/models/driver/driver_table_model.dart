import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_table_model.g.dart';

/// Таблица пилотов из ответа API по идентификатору.
@JsonSerializable()
class DriverTableModel {
  DriverTableModel({required this.drivers, required this.driverId});

  /// Создаёт модель из JSON ответа API.
  factory DriverTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('DriverTableModel: $e'), StackTrace.current);
    }
  }
  final String driverId;
  @JsonKey(name: 'Drivers')
  final List<DriverModel> drivers;
}
