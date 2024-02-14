import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_table_model.g.dart';

@JsonSerializable()
class DriverTableModel {
  DriverTableModel({
    required this.drivers,
    required this.driverId,
  });

  factory DriverTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$DriverTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('DriverTableModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String driverId;
  @JsonKey(name: 'Drivers')
  final List<DriverModel> drivers;
}
