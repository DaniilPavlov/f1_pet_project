// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircuitTableModel _$CircuitTableModelFromJson(Map<String, dynamic> json) =>
    CircuitTableModel(
      Circuits: (json['Circuits'] as List<dynamic>)
          .map((e) => CircuitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CircuitTableModelToJson(CircuitTableModel instance) =>
    <String, dynamic>{
      'Circuits': instance.Circuits,
    };
