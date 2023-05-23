import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/race_info_repository.dart';
import 'package:f1_pet_project/providers/results/race_info/race_info_data.dart';
import 'package:f1_pet_project/providers/results/race_info/race_year_round_parameter.dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final raceInfoDataProvider = FutureProvider.autoDispose
    .family<RaceInfoData, RaceYearRoundParameter>((ref, data) async {
  final pitStops = await ref.read(pitStopsProvider(data.yearRound).future);
  final qualifyingResults = ref.read(raceInfoErrorProvider) == null
      ? await ref.read(qualifyingProvider(data.yearRound).future)
      : null;

  return RaceInfoData(
    pitStops: pitStops,
    qualifyingResults: qualifyingResults,
  );
});

final raceInfoFastestLapProvider =
    StateProvider.family<String, RacesModel>((ref, race) {
  var result = '999999';
  for (final element in race.Results!) {
    if (element.FastestLap != null &&
        result.compareTo(element.FastestLap!.Time.time) == 1) {
      result = element.FastestLap!.Time.time;
    }
  }
  return result;
});

final pitStopsProvider = FutureProvider.family
    .autoDispose<List<PitStopsModel>?, List<String>>((ref, data) {
  final raceInfoRepository = ref.read(raceInfoRepositoryProvider);

  return raceInfoRepository.loadPitStops(
    year: data[0],
    round: data[1],
    ref: ref,
  );
});

final qualifyingProvider = FutureProvider.family
    .autoDispose<List<QualifyingResultsModel>?, List<String>>(
  (ref, data) {
    final raceInfoRepository = ref.read(raceInfoRepositoryProvider);

    return raceInfoRepository.loadQualifyingResults(
      year: data[0],
      round: data[1],
      ref: ref,
    );
  },
);

final raceAppBarPinnedProvider = StateProvider<bool>((ref) => false);

final qualificationAppBarPinnedProvider = StateProvider<bool>((ref) => false);

final pitStopsAppBarPinnedProvider = StateProvider<bool>((ref) => false);

final raceInfoErrorProvider = StateProvider<CustomException?>((ref) => null);

final raceInfoRepositoryProvider = Provider<RaceInfoRepository>((ref) {
  return RaceInfoRepository();
});