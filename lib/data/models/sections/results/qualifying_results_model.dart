// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'qualifying_results_model.g.dart';

@JsonSerializable()
class QualifyingResultsModel {
  final String number;
  final String position;
  final DriverModel Driver;
  final ConstructorModel Constructor;
  final String Q1;
  final String? Q2;
  final String? Q3;

  QualifyingResultsModel({
    required this.number,
    required this.position,
    required this.Driver,
    required this.Constructor,
    required this.Q1,
    required this.Q2,
    required this.Q3,
  });

  factory QualifyingResultsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$QualifyingResultsModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('QualifyingResultsModel: $e'),
        StackTrace.current,
      );
    }
  }
}
