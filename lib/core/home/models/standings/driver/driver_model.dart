import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  DriverModel({
    required this.driverId,
    required this.url,
    required this.givenName,
    required this.familyName,
    required this.dateOfBirth,
    required this.nationality,
    required this.code,
    required this.permanentNumber,
  }) {
    code ??= 'none';
    permanentNumber ??= 'none';
  }

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('DriverModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String driverId;
  final String url;
  final String givenName;
  final String familyName;
  final String dateOfBirth;
  final String nationality;
  String? permanentNumber;
  String? code;
}
