// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BaseResponseModel _$BaseResponseModelFromJson(Map<String, dynamic> json) =>
    _BaseResponseModel(
      mrData: json['MRData'],
      message: json['message'] as String?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BaseResponseModelToJson(_BaseResponseModel instance) =>
    <String, dynamic>{
      'MRData': instance.mrData,
      'message': instance.message,
      'code': instance.code,
    };
