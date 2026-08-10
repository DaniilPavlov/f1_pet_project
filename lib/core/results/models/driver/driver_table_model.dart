import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'driver_table_model.freezed.dart';
part 'driver_table_model.g.dart';

/// Таблица пилотов из ответа API по идентификатору.
@Freezed(fromJson: true, toJson: true)
abstract class DriverTableModel with _$DriverTableModel {
  const factory DriverTableModel({
    required String driverId,
    @JsonKey(name: 'Drivers') required List<DriverModel> drivers,
  }) = _DriverTableModel;

  /// Создаёт модель из JSON ответа API.
  factory DriverTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('DriverTableModel: $e'), StackTrace.current);
    }
  }
}
