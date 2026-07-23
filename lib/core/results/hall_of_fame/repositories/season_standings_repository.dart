import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Standings за выбранный сезон (Зал славы).
class SeasonStandingsRepository {
  const SeasonStandingsRepository();

  Future<StandingsModel> drivers({required String year}) => fetchAndParse(
    load: () => ApiLoader.get('$year/driverStandings'),
    parse: StandingsModel.fromJson,
  );

  Future<StandingsModel> constructors({required String year}) => fetchAndParse(
    load: () => ApiLoader.get('$year/constructorStandings'),
    parse: StandingsModel.fromJson,
  );
}
