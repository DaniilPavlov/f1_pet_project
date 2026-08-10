import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'average_speed_model.freezed.dart';
part 'average_speed_model.g.dart';

/// Средняя скорость на круге с единицами измерения.
@Freezed(fromJson: true, toJson: true)
abstract class AverageSpeedModel with _$AverageSpeedModel {
  const factory AverageSpeedModel({required String units, required String speed}) = _AverageSpeedModel;

  /// Создаёт модель из JSON ответа API.
  factory AverageSpeedModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$AverageSpeedModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('AverageSpeedModel: $e'), StackTrace.current);
    }
  }
}
