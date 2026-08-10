import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_model.freezed.dart';
part 'season_model.g.dart';

/// Сезон F1 из Jolpica (`seasons`).
@Freezed(fromJson: true, toJson: true)
abstract class SeasonModel with _$SeasonModel {
  const factory SeasonModel({required String season, required String url}) = _SeasonModel;

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SeasonModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('SeasonModel: $e'), StackTrace.current);
    }
  }
}
