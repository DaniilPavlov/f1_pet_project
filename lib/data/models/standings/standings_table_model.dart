import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'standings_table_model.freezed.dart';
part 'standings_table_model.g.dart';

/// Контейнер списков standings по сезонам и этапам.
@Freezed(fromJson: true, toJson: true)
abstract class StandingsTableModel with _$StandingsTableModel {
  const factory StandingsTableModel({
    @JsonKey(name: 'StandingsLists') required List<StandingsListsModel> standingsLists,
  }) = _StandingsTableModel;

  /// Парсит JSON-ответ в [StandingsTableModel].
  factory StandingsTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('StandingsTableModel: $e'), StackTrace.current);
    }
  }
}
