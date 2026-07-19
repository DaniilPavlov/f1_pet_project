import 'package:f1_pet_project/core/seasons/models/season_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season_table_model.g.dart';

/// Таблица сезонов из ответа API.
@JsonSerializable()
class SeasonTableModel {
  SeasonTableModel({required this.seasons});

  factory SeasonTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SeasonTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('SeasonTableModel: $e'), StackTrace.current);
    }
  }

  @JsonKey(name: 'Seasons')
  final List<SeasonModel> seasons;
}
