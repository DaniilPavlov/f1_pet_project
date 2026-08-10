import 'package:f1_pet_project/common/models/seasons/season_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'seasons_model.freezed.dart';
part 'seasons_model.g.dart';

/// Корневая модель ответа API со списком сезонов.
@Freezed(fromJson: true, toJson: true)
abstract class SeasonsModel with _$SeasonsModel {
  const factory SeasonsModel({
    @JsonKey(name: 'SeasonTable') required SeasonTableModel seasonTable,
  }) = _SeasonsModel;

  factory SeasonsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SeasonsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('SeasonsModel: $e'), StackTrace.current);
    }
  }
}
