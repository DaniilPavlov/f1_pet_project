import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/current_drivers_standings/current_drivers_standings_loader.dart';

class HomeScreenModel extends ElementaryModel {
  Future<CurrentDriversStandings> loadCurrentDriversStandings() async {
    final rawData = await CurrentDriversStandingsLoader.loadData();

    return CurrentDriversStandings.fromJson(rawData.MRData as Map<String, dynamic>);
  }
}
