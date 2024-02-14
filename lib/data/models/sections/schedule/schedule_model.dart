import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/schedule/race_table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  ScheduleModel({required this.raceTable});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ScheduleModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('ScheduleModel: $e'),
        StackTrace.current,
      );
    }
  }
  @JsonKey(name: 'RaceTable')
  final RaceTableModel raceTable;
}
