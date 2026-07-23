import 'package:f1_pet_project/common/models/seasons/season_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seasons_model.g.dart';

/// Корневая модель ответа API со списком сезонов.
@JsonSerializable()
class SeasonsModel {
  SeasonsModel({required this.seasonTable});

  factory SeasonsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SeasonsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('SeasonsModel: $e'), StackTrace.current);
    }
  }

  @JsonKey(name: 'SeasonTable')
  final SeasonTableModel seasonTable;
}
