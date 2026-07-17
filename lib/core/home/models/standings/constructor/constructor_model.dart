import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constructor_model.g.dart';

/// Данные команды F1.
@JsonSerializable()
class ConstructorModel {
  ConstructorModel({
    required this.constructorId,
    required this.url,
    required this.nationality,
    required this.name,
  });

  /// Парсит JSON-ответ в [ConstructorModel].
  factory ConstructorModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('ConstructorModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String constructorId;
  final String url;
  final String name;
  final String nationality;
}
