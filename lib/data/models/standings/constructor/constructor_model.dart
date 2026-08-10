import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'constructor_model.freezed.dart';
part 'constructor_model.g.dart';

/// Данные команды F1.
@Freezed(fromJson: true, toJson: true)
abstract class ConstructorModel with _$ConstructorModel {
  const factory ConstructorModel({
    required String constructorId,
    @JsonKey(defaultValue: '') required String url,
    required String name,
    @JsonKey(defaultValue: '') required String nationality,
  }) = _ConstructorModel;

  /// Парсит JSON-ответ в [ConstructorModel].
  factory ConstructorModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('ConstructorModel: $e'), StackTrace.current);
    }
  }
}
