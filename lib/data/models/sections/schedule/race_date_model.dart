import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'race_date_model.g.dart';

@JsonSerializable()
class RaceDateModel {
  RaceDateModel({
    required this.date,
    required this.time,
  });

  factory RaceDateModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceDateModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('RaceDateModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String date;
  final String time;
}
