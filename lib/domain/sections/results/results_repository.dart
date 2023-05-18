import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/last_race_results_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/providers/results/results_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultsRepository {
  Future<RacesModel?> loadLastRaceResults(
    AutoDisposeFutureProviderRef<RacesModel?> ref,
  ) async {
    RacesModel? result;
    await execute<ScheduleModel>(
      () async {
        final rawData = await LastRaceResultsLoader.loadData();

        return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      onSuccess: (data) {
        result = data!.RaceTable.Races[0];
        ref.read(resultsErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(resultsErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }
}
