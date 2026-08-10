import 'package:f1_pet_project/common/models/seasons/season_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_table_model.freezed.dart';
part 'season_table_model.g.dart';

/// Таблица сезонов из ответа API.
@Freezed(fromJson: true, toJson: true)
abstract class SeasonTableModel with _$SeasonTableModel {
  const factory SeasonTableModel({
    @JsonKey(name: 'Seasons') required List<SeasonModel> seasons,
  }) = _SeasonTableModel;

  factory SeasonTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SeasonTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('SeasonTableModel: $e'), StackTrace.current);
    }
  }
}
