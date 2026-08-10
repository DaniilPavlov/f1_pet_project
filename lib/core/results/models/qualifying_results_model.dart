import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qualifying_results_model.freezed.dart';
part 'qualifying_results_model.g.dart';

/// Результат пилота в квалификации (Q1–Q3).
@Freezed(fromJson: true, toJson: true)
abstract class QualifyingResultsModel with _$QualifyingResultsModel {
  const factory QualifyingResultsModel({
    required String number,
    required String position,
    @JsonKey(name: 'Driver') required DriverModel driver,
    @JsonKey(name: 'Constructor') required ConstructorModel constructor,
    @JsonKey(name: 'Q1') required String q1,
    @JsonKey(name: 'Q2') String? q2,
    @JsonKey(name: 'Q3') String? q3,
  }) = _QualifyingResultsModel;

  /// Создаёт модель из JSON ответа API.
  factory QualifyingResultsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$QualifyingResultsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('QualifyingResultsModel: $e'), StackTrace.current);
    }
  }
}
