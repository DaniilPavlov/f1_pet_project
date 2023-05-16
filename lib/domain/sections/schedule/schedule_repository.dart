import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';

// TODO(pavlov): обрабатывать ошибки неудобно и пока не ясно как
class ScheduleRepository {
  Future<List<RacesModel>?> loadSchedule() async {
    List<RacesModel>? result;
    await execute<ScheduleModel>(
      () async {
        final rawData = await ScheduleLoader.loadData();

        return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      // before: _circuits.loading,
      onSuccess: (data) {
        result = data!.RaceTable.Races;
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _circuits.error(value);
      // },
    );
    return result;
  }
}
