import 'package:f1_pet_project/core/results/models/driver/driver_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'driver_fetching_model.freezed.dart';
part 'driver_fetching_model.g.dart';

/// Обёртка ответа API с данными пилота.
@Freezed(fromJson: true, toJson: true)
abstract class DriverFetchingModel with _$DriverFetchingModel {
  const factory DriverFetchingModel({
    @JsonKey(name: 'DriverTable') required DriverTableModel driverTable,
  }) = _DriverFetchingModel;

  /// Создаёт модель из JSON ответа API.
  factory DriverFetchingModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverFetchingModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('DriverFetchingModel: $e'), StackTrace.current);
    }
  }
}
