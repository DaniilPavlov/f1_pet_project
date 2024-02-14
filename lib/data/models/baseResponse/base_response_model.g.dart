// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponseModel _$BaseResponseModelFromJson(Map<String, dynamic> json) =>
    BaseResponseModel(
      mrData: json['MRData'],
      code: json['code'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BaseResponseModelToJson(BaseResponseModel instance) =>
    <String, dynamic>{
      'MRData': instance.mrData,
      'message': instance.message,
      'code': instance.code,
    };
