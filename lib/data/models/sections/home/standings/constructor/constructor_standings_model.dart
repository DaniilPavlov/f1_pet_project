import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constructor_standings_model.g.dart';

@JsonSerializable()
class ConstructorStandingsModel {
  ConstructorStandingsModel({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.constructor,
  });

  factory ConstructorStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorStandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('ConstructorStandingsModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String position;
  final String positionText;
  final String points;
  final String wins;
  @JsonKey(name: 'Constructor')
  final ConstructorModel constructor;
}
