import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'races_model.g.dart';

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

  factory RacesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RacesModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('RacesModel: $e'),
        StackTrace.current,
      );
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
}
