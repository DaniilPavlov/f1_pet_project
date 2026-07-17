import 'package:f1_pet_project/core/home/models/standings/standings_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_model.g.dart';

/// Модель ответа API с турнирной таблицей.
@JsonSerializable()
class StandingsModel {
  StandingsModel({required this.standingsTable});

  /// Парсит JSON-ответ в [StandingsModel].
  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('StandingsModel: $e'), StackTrace.current);
    }
  }
  @JsonKey(name: 'StandingsTable')
  final StandingsTableModel standingsTable;
}
