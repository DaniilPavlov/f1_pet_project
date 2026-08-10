import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_table_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'standings_model.freezed.dart';
part 'standings_model.g.dart';

/// Модель ответа API с турнирной таблицей.
@Freezed(fromJson: true, toJson: true)
abstract class StandingsModel with _$StandingsModel {
  const factory StandingsModel({
    @JsonKey(name: 'StandingsTable') required StandingsTableModel standingsTable,
  }) = _StandingsModel;

  /// Парсит JSON-ответ в [StandingsModel].
  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('StandingsModel: $e'), StackTrace.current);
    }
  }
}
