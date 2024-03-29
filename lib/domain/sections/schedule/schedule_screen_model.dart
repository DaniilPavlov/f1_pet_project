import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_loader.dart';

class ScheduleScreenModel extends ElementaryModel {
  Future<ScheduleModel> loadSchedule() async {
    final rawData = await ScheduleLoader.loadData();

    return ScheduleModel.fromJson(rawData.mrData as Map<String, dynamic>);
  }
}
