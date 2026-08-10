import 'package:f1_pet_project/core/results/models/fastest_lap_model.dart';
import 'package:f1_pet_project/core/results/models/time_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'results_model.freezed.dart';
part 'results_model.g.dart';

/// Результат одного пилота в финишной таблице гонки.
@Freezed(fromJson: true, toJson: true)
abstract class ResultsModel with _$ResultsModel {
  const ResultsModel._();

  const factory ResultsModel({
    required String number,
    required String position,
    required String positionText,
    required String points,
    @JsonKey(name: 'Driver') required DriverModel driver,
    @JsonKey(name: 'Constructor') required ConstructorModel constructor,
    required String grid,
    required String laps,
    required String status,
    @JsonKey(name: 'Time') TimeModel? time,
    @JsonKey(name: 'FastestLap') FastestLapModel? fastestLap,
  }) = _ResultsModel;

  /// Создаёт модель из JSON ответа API.
  factory ResultsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ResultsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('ResultsModel: $e'), StackTrace.current);
    }
  }
  /// Классифицирован (есть финишная позиция), а не DNF / DSQ.
  bool get isClassified => int.tryParse(positionText) != null;
  /// Время круга/отставания или статус (Retired, Engine, …).
  String get displayTimeOrStatus {
    final raceTime = time?.time.trim();
    if (raceTime != null && raceTime.isNotEmpty) {
      return raceTime;
    }
    return status;
  }
}
