import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

/// Модель ответа API с таблицей гонок сезона.
@JsonSerializable()
class ScheduleModel {
  ScheduleModel({required this.raceTable});

  /// Парсит JSON-ответ в [ScheduleModel].
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ScheduleModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('ScheduleModel: $e'), StackTrace.current);
    }
  }
  @JsonKey(name: 'RaceTable')
  final RaceTableModel raceTable;
}
