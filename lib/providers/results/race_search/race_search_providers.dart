import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO(pavlov): делать FutureProvider только для загрузки
// данные сохранять в отдельные провайдеры
final raceSearchLoadResultsProvider = FutureProvider.autoDispose
    .family<RacesModel?, List<String>?>((ref, data) async {
  final raceSearchRepository = ref.read(raceSearchRepositoryProvider);
  if (data == null) {
    return null;
  }
  final raceSearch =
      await raceSearchRepository.loadRaceResults(year: data[0], round: data[1]);

  if (raceSearch != null) {
    for (final element in raceSearch.Results!) {
      if (element.FastestLap != null &&
          ref
                  .read(fastestLapProvider)
                  .compareTo(element.FastestLap!.Time.time) ==
              1) {
        ref
            .read(fastestLapProvider.notifier)
            .update((state) => element.FastestLap!.Time.time);
      }
    }
  }

  // ref.read(raceSearchResultsProvider.notifier).update((state) => raceSearch);

  return raceSearch;
});

final raceSearchResultsProvider = StateProvider<RacesModel?>((ref) => null);

final raceSearchFieldsInputtedProvider = StateProvider<bool>((ref) => false);

final fastestLapProvider = StateProvider<String>((ref) => '999999');

final raceSearchRepositoryProvider = Provider<RaceSearchRepository>((ref) {
  return RaceSearchRepository();
});
