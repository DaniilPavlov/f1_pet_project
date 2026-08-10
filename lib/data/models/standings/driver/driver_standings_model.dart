import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_standings_model.freezed.dart';
part 'driver_standings_model.g.dart';

/// Позиция пилота в турнирной таблице.
@Freezed(fromJson: true, toJson: true)
abstract class DriverStandingsModel with _$DriverStandingsModel {
  const factory DriverStandingsModel({
    @JsonKey(defaultValue: '') required String position,
    @JsonKey(defaultValue: '') required String positionText,
    @JsonKey(defaultValue: '0') required String points,
    @JsonKey(defaultValue: '0') required String wins,
    @JsonKey(name: 'Driver') required DriverModel driver,
    @JsonKey(name: 'Constructors', defaultValue: <ConstructorModel>[])
    required List<ConstructorModel> constructors,
  }) = _DriverStandingsModel;

  /// Парсит JSON-ответ в [DriverStandingsModel].
  factory DriverStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverStandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('DriverStandingsModel: $e'), StackTrace.current);
    }
  }
}
