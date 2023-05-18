import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
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
  final currentDrivers = ref.read(homeErrorProvider) == null
      ? await ref.read(currentDriverStandingsProvider.future)
      : null;

  return HomeData(
    constructors: currentConstructors,
    drivers: currentDrivers,
    season: ref.read(currentSeasonProvider),
    round: ref.read(currentRoundProvider),
  );
});

final currentSeasonProvider = StateProvider<String?>((ref) => null);

final currentRoundProvider = StateProvider<String?>((ref) => null);

final currentConstructorStandingsProvider =
    FutureProvider.autoDispose<List<ConstructorStandingsModel>?>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);

  return homeRepository.loadCurrentConstructorsStandings(ref);
});

final currentDriverStandingsProvider =
    FutureProvider.autoDispose<List<DriverStandingsModel>?>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);

  return homeRepository.loadCurrentDriversStandings(ref);
});

final homeErrorProvider = StateProvider<CustomException?>((ref) => null);

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});
