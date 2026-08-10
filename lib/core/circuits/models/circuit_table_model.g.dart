// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircuitTableModel _$CircuitTableModelFromJson(Map<String, dynamic> json) =>
    _CircuitTableModel(
      circuits: (json['Circuits'] as List<dynamic>)
          .map((e) => CircuitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CircuitTableModelToJson(_CircuitTableModel instance) =>
    <String, dynamic>{'Circuits': instance.circuits};
