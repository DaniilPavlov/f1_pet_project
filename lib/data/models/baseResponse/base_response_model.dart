import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';

import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable()

/// Базовая модель ответа API с полем MRData.
class BaseResponseModel {
  /// Создаёт модель из JSON; при ошибке бросает [ResponseParseException].
  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      final res = _$BaseResponseModelFromJson(json);

      return res;
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('BaseResponseRepository: $e'),
        StackTrace.current,
      );
    }
  }

  const BaseResponseModel({
    required this.mrData,
    this.code,
    this.message,
  });

  /// Полезная нагрузка ответа (MRData).
  @JsonKey(name: 'MRData')
  final dynamic mrData;

  final String? message;

  final int? code;

  /// Преобразует модель в JSON.
  Map<String, dynamic> toJson() => _$BaseResponseModelToJson(this);
}
