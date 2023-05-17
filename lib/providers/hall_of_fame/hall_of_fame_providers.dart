import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_repository.dart';
import 'package:f1_pet_project/providers/hall_of_fame/hall_of_fame_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hallOfFameDataProvider =
    FutureProvider.autoDispose<HallOfFameData>((ref) async {
  final constructors = await ref.read(constructorsChampionsProvider.future);
  final drivers = await ref.read(driversChampionsProvider.future);

  return HallOfFameData(constructors: constructors, drivers: drivers);
});

final constructorsChampionsProvider =
    FutureProvider.autoDispose<List<StandingsListsModel>?>((ref) {
  final hallOfFameRepository = ref.read(hallOfFameRepositoryProvider);

  return hallOfFameRepository.loadConstructorsChampions();
});

final driversChampionsProvider =
    FutureProvider.autoDispose<List<StandingsListsModel>?>((ref) {
  final hallOfFameRepository = ref.read(hallOfFameRepositoryProvider);

  return hallOfFameRepository.loadDriversChampions();
});

final hallOfFameRepositoryProvider = Provider<HallOfFameRepository>((ref) {
  return HallOfFameRepository();
});
