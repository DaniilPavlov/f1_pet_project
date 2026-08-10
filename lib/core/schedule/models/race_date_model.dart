import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'race_date_model.freezed.dart';
part 'race_date_model.g.dart';

/// Дата и время сессии или гонки.
@Freezed(fromJson: true, toJson: true)
abstract class RaceDateModel with _$RaceDateModel {
  const factory RaceDateModel({required String date, required String time}) = _RaceDateModel;

  /// Парсит JSON-ответ в [RaceDateModel].
  factory RaceDateModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceDateModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('RaceDateModel: $e'), StackTrace.current);
    }
  }
}
