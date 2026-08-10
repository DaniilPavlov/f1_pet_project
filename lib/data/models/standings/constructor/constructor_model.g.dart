// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constructor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConstructorModel _$ConstructorModelFromJson(Map<String, dynamic> json) =>
    _ConstructorModel(
      constructorId: json['constructorId'] as String,
      url: json['url'] as String? ?? '',
      name: json['name'] as String,
      nationality: json['nationality'] as String? ?? '',
    );

Map<String, dynamic> _$ConstructorModelToJson(_ConstructorModel instance) =>
    <String, dynamic>{
      'constructorId': instance.constructorId,
      'url': instance.url,
      'name': instance.name,
      'nationality': instance.nationality,
    };
