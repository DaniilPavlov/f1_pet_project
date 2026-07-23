import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season_model.g.dart';

/// Сезон F1 из Jolpica (`seasons`).
@JsonSerializable()
class SeasonModel {
  SeasonModel({required this.season, required this.url});

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SeasonModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('SeasonModel: $e'), StackTrace.current);
    }
  }

  final String season;
  final String url;
}
