import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_repository.dart';
import 'package:f1_pet_project/providers/results/race_info/race_year_round_parameter.dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO(info): делать FutureProvider только для загрузки
// данные сохранять в отдельные провайдеры
final raceSearchLoadResultsProvider =
    FutureProvider.autoDispose<RacesModel?>((ref) async {
  final raceYearRound = ref.watch(raceYearRoundProvider);
  if (raceYearRound == null) {
    return null;
  }

  final raceSearchRepository = ref.read(raceSearchRepositoryProvider);

  final raceSearch = await raceSearchRepository.loadRaceResults(
    year: raceYearRound.yearRound[0],
    round: raceYearRound.yearRound[1],
  );

  if (raceSearch != null) {
    for (final element in raceSearch.Results!) {
      if (element.FastestLap != null &&
          ref
                  .read(raceSearchFastestLapProvider)
                  .compareTo(element.FastestLap!.Time.time) ==
              1) {
        ref
            .read(raceSearchFastestLapProvider.notifier)
            .update((state) => element.FastestLap!.Time.time);
      }
    }
  }

  return raceSearch;
});

final raceSearchResultsProvider = StateProvider<RacesModel?>((ref) => null);

final raceYearRoundProvider =
    StateProvider<RaceYearRoundParameter?>((ref) => null);

final raceSearchFieldsInputtedProvider = StateProvider<bool>((ref) => false);

final raceSearchFastestLapProvider = StateProvider<String>((ref) => '999999');

final raceSearchRepositoryProvider = Provider<RaceSearchRepository>((ref) {
  return RaceSearchRepository();
});
