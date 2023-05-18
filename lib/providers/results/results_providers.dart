import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/results_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resultsDataProvider =
    FutureProvider.autoDispose<RacesModel?>((ref) async {
  final lastRaceResults = await ref.read(lastRaceSesultsProvider.future);
  if (lastRaceResults != null) {
    for (final element in lastRaceResults.Results!) {
      if (element.FastestLap != null &&
          ref
                  .read(resultsFastestLapProvider)
                  .compareTo(element.FastestLap!.Time.time) ==
              1) {
        ref.read(resultsFastestLapProvider.notifier).state =
            element.FastestLap!.Time.time;
      }
    }
  }

  return lastRaceResults;
});

final resultsFastestLapProvider = StateProvider<String>((ref) {
  return '999999';
});

final lastRaceSesultsProvider = FutureProvider.autoDispose<RacesModel?>((ref) {
  final resultsRepository = ref.read(resultsRepositoryProvider);

  return resultsRepository.loadLastRaceResults();
});

final resultsRepositoryProvider = Provider<ResultsRepository>((ref) {
  return ResultsRepository();
});
