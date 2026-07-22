import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constructor_standings_model.g.dart';

/// Позиция команды в турнирной таблице конструкторов.
@JsonSerializable()
class ConstructorStandingsModel {
  ConstructorStandingsModel({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.constructor,
  });

  /// Парсит JSON-ответ в [ConstructorStandingsModel].
  factory ConstructorStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorStandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('ConstructorStandingsModel: $e'), StackTrace.current);
    }
  }
  final String position;
  final String positionText;
  final String points;
  final String wins;
  @JsonKey(name: 'Constructor')
  final ConstructorModel constructor;
}
