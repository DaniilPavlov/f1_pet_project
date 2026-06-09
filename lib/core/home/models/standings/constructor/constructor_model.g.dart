// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constructor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConstructorModel _$ConstructorModelFromJson(Map<String, dynamic> json) =>
    ConstructorModel(
      constructorId: json['constructorId'] as String,
      url: json['url'] as String,
      nationality: json['nationality'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ConstructorModelToJson(ConstructorModel instance) =>
    <String, dynamic>{
      'constructorId': instance.constructorId,
      'url': instance.url,
      'name': instance.name,
      'nationality': instance.nationality,
    };
