import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'races_model.freezed.dart';
part 'races_model.g.dart';

/// Данные гонки с сессиями, результатами и пит-стопами.
@Freezed(fromJson: true, toJson: true)
abstract class RacesModel with _$RacesModel {
  const RacesModel._();

  const factory RacesModel({
    required String season,
    required String round,
    required String url,
    required String raceName,
    @JsonKey(name: 'Circuit') required CircuitModel circuit,
    required String date,
    String? time,
    @JsonKey(name: 'FirstPractice') RaceDateModel? firstPractice,
    @JsonKey(name: 'SecondPractice') RaceDateModel? secondPractice,
    @JsonKey(name: 'ThirdPractice') RaceDateModel? thirdPractice,
    @JsonKey(name: 'Qualifying') RaceDateModel? qualifying,
    /// Дата и время спринт-квалификации (сетка на спринт).
    @JsonKey(name: 'SprintQualifying') RaceDateModel? sprintQualifying,
    @JsonKey(name: 'Sprint') RaceDateModel? sprint,
    @JsonKey(name: 'Results') List<ResultsModel>? results,
    @JsonKey(name: 'SprintResults') List<ResultsModel>? sprintResults,
    @JsonKey(name: 'QualifyingResults') List<QualifyingResultsModel>? qualifyingResults,
    @JsonKey(name: 'PitStops') List<PitStopsModel>? pitStops,
  }) = _RacesModel;

  /// Парсит JSON-ответ в [RacesModel].
  factory RacesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RacesModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('RacesModel: $e'), StackTrace.current);
    }
  }
  /// Находит лучший круг среди результатов гонки.
  String get fastestLapTime => fastestLapAmong(results);
  /// Находит лучший круг среди результатов спринта.
  String get fastestSprintLapTime => fastestLapAmong(sprintResults);
  /// Находит лучший круг в переданном списке результатов.
  static String fastestLapAmong(List<ResultsModel>? list) {
    var fastest = '999999';
    for (final result in list ?? const <ResultsModel>[]) {
      final lap = result.fastestLap?.time.time;
      if (lap != null && fastest.compareTo(lap) > 0) {
        fastest = lap;
      }
    }
    return fastest;
  }
}
