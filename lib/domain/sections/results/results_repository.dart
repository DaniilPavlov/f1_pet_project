import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/last_race_results_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';

// TODO(pavlov): обрабатывать ошибки неудобно и пока не ясно как
class ResultsRepository {
  Future<RacesModel?> loadLastRaceResults() async {
    RacesModel? result;
    await execute<ScheduleModel>(
      () async {
        final rawData = await LastRaceResultsLoader.loadData();

        return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      // before: _constructorsChampions.loading,
      onSuccess: (data) {
        result = data!.RaceTable.Races[0];
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _constructorsChampions.error(value);
      // },
    );
    return result;
  }
}
