import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_model.g.dart';

@JsonSerializable()
class TimeModel {
  TimeModel({
    required this.millis,
    required this.time,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$TimeModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('TimeModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String? millis;
  final String time;
}
