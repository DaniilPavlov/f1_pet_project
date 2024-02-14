import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'qualifying_results_model.g.dart';

@JsonSerializable()
class QualifyingResultsModel {
  QualifyingResultsModel({
    required this.number,
    required this.position,
    required this.driver,
    required this.constructor,
    required this.q1,
    required this.q2,
    required this.q3,
  });

  factory QualifyingResultsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$QualifyingResultsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('QualifyingResultsModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String number;
  final String position;
  @JsonKey(name: 'Driver')
  final DriverModel driver;
  @JsonKey(name: 'Constructor')
  final ConstructorModel constructor;
  @JsonKey(name: 'Q1')
  final String q1;
  @JsonKey(name: 'Q2')
  final String? q2;
  @JsonKey(name: 'Q3')
  final String? q3;
}
