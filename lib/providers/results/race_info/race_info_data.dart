import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';

class RaceInfoData {
  final List<PitStopsModel>? pitStops;
  final List<QualifyingResultsModel>? qualifyingResults;

  RaceInfoData({
    required this.pitStops,
    required this.qualifyingResults,
  });
}
