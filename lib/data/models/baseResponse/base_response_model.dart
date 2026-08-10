import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response_model.freezed.dart';
part 'base_response_model.g.dart';

/// Базовая модель ответа API с полем MRData.
@Freezed(fromJson: true, toJson: true)
abstract class BaseResponseModel with _$BaseResponseModel {
  const factory BaseResponseModel({
    /// Полезная нагрузка ответа (MRData).
    @JsonKey(name: 'MRData') required dynamic mrData,
    String? message,
    int? code,
  }) = _BaseResponseModel;

  /// Создаёт модель из JSON; при ошибке бросает [ResponseParseException].
  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$BaseResponseModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('BaseResponseRepository: $e'), StackTrace.current);
    }
  }
}
