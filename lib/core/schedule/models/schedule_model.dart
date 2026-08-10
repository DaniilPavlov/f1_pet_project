import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

/// Модель ответа API с таблицей гонок сезона.
@Freezed(fromJson: true, toJson: true)
abstract class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    @JsonKey(name: 'RaceTable') required RaceTableModel raceTable,
  }) = _ScheduleModel;

  /// Парсит JSON-ответ в [ScheduleModel].
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ScheduleModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('ScheduleModel: $e'), StackTrace.current);
    }
  }
}
