import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'races_model.g.dart';

/// Данные гонки с сессиями, результатами и пит-стопами.
@JsonSerializable()
class RacesModel {
  RacesModel({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.circuit,
    required this.date,
    required this.time,
    required this.firstPractice,
    required this.secondPractice,
    required this.thirdPractice,
    required this.qualifying,
    required this.sprint,
    required this.results,
    required this.qualifyingResults,
    required this.pitStops,
  });

  /// Парсит JSON-ответ в [RacesModel].
  factory RacesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RacesModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('RacesModel: $e'), StackTrace.current);
    }
  }
  final String season;
  final String round;
  final String url;
  final String raceName;
  @JsonKey(name: 'Circuit')
  final CircuitModel circuit;
  final String date;
  final String? time;
  @JsonKey(name: 'FirstPractice')
  final RaceDateModel? firstPractice;
  @JsonKey(name: 'SecondPractice')
  final RaceDateModel? secondPractice;
  @JsonKey(name: 'ThirdPractice')
  final RaceDateModel? thirdPractice;
  @JsonKey(name: 'Qualifying')
  final RaceDateModel? qualifying;
  @JsonKey(name: 'Sprint')
  final RaceDateModel? sprint;
  @JsonKey(name: 'Results')
  final List<ResultsModel>? results;
  @JsonKey(name: 'QualifyingResults')
  final List<QualifyingResultsModel>? qualifyingResults;
  @JsonKey(name: 'PitStops')
  final List<PitStopsModel>? pitStops;

  /// Находит лучший круг гонки среди результатов.
  String get fastestLapTime {
    var fastest = '999999';
    for (final result in results ?? const <ResultsModel>[]) {
      final lap = result.fastestLap?.time.time;
      if (lap != null && fastest.compareTo(lap) > 0) {
        fastest = lap;
      }
    }
    return fastest;
  }
}
