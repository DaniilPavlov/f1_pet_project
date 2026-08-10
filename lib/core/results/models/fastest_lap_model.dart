import 'package:f1_pet_project/core/results/models/average_speed_model.dart';
import 'package:f1_pet_project/core/results/models/time_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fastest_lap_model.freezed.dart';
part 'fastest_lap_model.g.dart';

/// Информация о лучшем круге пилота в гонке.
@Freezed(fromJson: true, toJson: true)
abstract class FastestLapModel with _$FastestLapModel {
  const factory FastestLapModel({
    required String rank,
    required String lap,
    @JsonKey(name: 'Time') required TimeModel time,
    @JsonKey(name: 'AverageSpeed') AverageSpeedModel? averageSpeed,
  }) = _FastestLapModel;

  /// Создаёт модель из JSON ответа API.
  factory FastestLapModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$FastestLapModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('FastestLapModel: $e'), StackTrace.current);
    }
  }
}
