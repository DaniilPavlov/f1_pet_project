import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'standings_lists_model.freezed.dart';
part 'standings_lists_model.g.dart';

/// Standings пилотов и конструкторов за конкретный сезон и этап.
@Freezed(fromJson: true, toJson: true)
abstract class StandingsListsModel with _$StandingsListsModel {
  const factory StandingsListsModel({
    required String season,
    required String round,
    @JsonKey(name: 'ConstructorStandings') List<ConstructorStandingsModel>? constructorStandings,
    @JsonKey(name: 'DriverStandings') List<DriverStandingsModel>? driverStandings,
  }) = _StandingsListsModel;

  /// Парсит JSON-ответ в [StandingsListsModel].
  factory StandingsListsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsListsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('StandingsListsModel: $e'), StackTrace.current);
    }
  }
}
