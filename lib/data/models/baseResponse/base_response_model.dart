// ignore_for_file: avoid_catches_without_on_clauses, non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';

import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable()

/// Модель ответа на запрос.
class BaseResponseModel {
  /// Данные в ответе на запрос.
  ///
  /// Чаще всего бывает [Map] или [List].
  final dynamic MRData;

  /// Результат выполнения запроса.
  // final bool success;

  /// Некое сообщение.
  ///
  /// Обычно присутствует если [] == false.
  final String? message;

  final int? code;
  const BaseResponseModel({
    required this.MRData,
    // required this.success,
    this.code,
    this.message,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    // if (json['success'] is! bool) {
    // throw ResponseParseException(
    //   'Ответ от сервера не содержит success',
    //   StackTrace.current,
    // );
    // }

    // if ((json['code'] as int?) == 403) {
    //   throw AccessError(json['message'] as String? ?? 'Ошибка доступа');
    // }

    // if (json['success'] == false) {
    //  throw SuccessFalse(
    //         json['message'] as String? ?? 'Произошла ошибка',
    //         StackTrace.current,
    //       );
    // }

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

  Map<String, dynamic> toJson() => _$BaseResponseModelToJson(this);
}
