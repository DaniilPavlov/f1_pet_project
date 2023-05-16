import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_repository.dart';
import 'package:f1_pet_project/providers/home/home_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeActiveTableProvider = StateProvider<int>((ref) {
  return 0;
});

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final currentConstructors =
      await ref.read(currentConstructorStandingsProvider.future);
  final currentDrivers = await ref.read(currentDriverStandingsProvider.future);
  final currentSeason = await ref.read(currentSeasonProvider.future);
  final currentRound = await ref.read(currentRoundProvider.future);

  return HomeData(
    constructors: currentConstructors,
    drivers: currentDrivers,
    season: currentSeason,
    round: currentRound,
  );
});

final currentSeasonProvider = FutureProvider.autoDispose<String?>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);

  return homeRepository.loadCurrentSeason();
});

final currentRoundProvider = FutureProvider.autoDispose<String?>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);

  return homeRepository.loadCurrentRound();
});

final currentConstructorStandingsProvider =
    FutureProvider.autoDispose<List<ConstructorStandingsModel>?>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);

  return homeRepository.loadCurrentConstructorsStandings();
});

final currentDriverStandingsProvider =
    FutureProvider.autoDispose<List<DriverStandingsModel>?>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);

  return homeRepository.loadCurrentDriversStandings();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});
