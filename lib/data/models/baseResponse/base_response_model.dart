import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';

import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable()

/// Api response model.
class BaseResponseModel {
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

  /// Response's data.
  @JsonKey(name: 'MRData')
  final dynamic mrData;

  final String? message;

  final int? code;

  Map<String, dynamic> toJson() => _$BaseResponseModelToJson(this);
}
