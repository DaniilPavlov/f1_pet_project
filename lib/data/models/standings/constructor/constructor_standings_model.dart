import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'constructor_standings_model.freezed.dart';
part 'constructor_standings_model.g.dart';

/// Позиция команды в турнирной таблице конструкторов.
@Freezed(fromJson: true, toJson: true)
abstract class ConstructorStandingsModel with _$ConstructorStandingsModel {
  const factory ConstructorStandingsModel({
    @JsonKey(defaultValue: '') required String position,
    @JsonKey(defaultValue: '') required String positionText,
    @JsonKey(defaultValue: '0') required String points,
    @JsonKey(defaultValue: '0') required String wins,
    @JsonKey(name: 'Constructor') required ConstructorModel constructor,
  }) = _ConstructorStandingsModel;

  /// Парсит JSON-ответ в [ConstructorStandingsModel].
  factory ConstructorStandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorStandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('ConstructorStandingsModel: $e'), StackTrace.current);
    }
  }
}
