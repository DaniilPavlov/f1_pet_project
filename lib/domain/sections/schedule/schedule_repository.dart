import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/providers/schedule/schedule_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleRepository {
  Future<List<RacesModel>?> loadSchedule(
    AutoDisposeFutureProviderRef<List<RacesModel>?> ref,
  ) async {
    List<RacesModel>? result;
    await execute<ScheduleModel>(
      () async {
        final rawData = await ScheduleLoader.loadData();
        return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      onSuccess: (data) {
        result = data!.RaceTable.Races;
        ref.read(scheduleErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(scheduleErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }
}
