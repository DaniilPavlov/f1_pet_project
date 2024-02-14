import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'average_speed_model.g.dart';

@JsonSerializable()
class AverageSpeedModel {
  AverageSpeedModel({
    required this.units,
    required this.speed,
  });

  factory AverageSpeedModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$AverageSpeedModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('AverageSpeedModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String units;
  final String speed;
}
