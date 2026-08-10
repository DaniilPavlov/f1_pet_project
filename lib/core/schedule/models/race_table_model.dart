import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'race_table_model.freezed.dart';
part 'race_table_model.g.dart';

/// Таблица гонок текущего сезона.
@Freezed(fromJson: true, toJson: true)
abstract class RaceTableModel with _$RaceTableModel {
  const RaceTableModel._();

  const factory RaceTableModel({
    /// В ответах `circuits/.../results` season на уровне таблицы отсутствует.
    @JsonKey(defaultValue: '') required String season,
    @JsonKey(name: 'Races') required List<RacesModel> races,
    String? round,
  }) = _RaceTableModel;

  /// Парсит JSON-ответ в [RaceTableModel].
  factory RaceTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('RaceTableModel: $e'), StackTrace.current);
    }
  }
  @override
  String toString() => 'RaceTableModel(season: $season, round: $round, Races: $races)';
}
