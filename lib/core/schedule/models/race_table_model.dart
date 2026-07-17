import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'race_table_model.g.dart';

/// Таблица гонок текущего сезона.
@JsonSerializable()
class RaceTableModel {
  RaceTableModel({required this.races, required this.season, required this.round});

  /// Парсит JSON-ответ в [RaceTableModel].
  factory RaceTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('RaceTableModel: $e'), StackTrace.current);
    }
  }
  final String season;
  final String? round;
  @JsonKey(name: 'Races')
  final List<RacesModel> races;

  @override
  String toString() => 'RaceTableModel(season: $season, round: $round, Races: $races)';
}
