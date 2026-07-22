import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Текущие standings Jolpica.
class CurrentStandingsRepository {
  const CurrentStandingsRepository();

  Future<StandingsModel> drivers() => fetchAndParse(
    load: () => ApiLoader.get('current/driverStandings'),
    parse: StandingsModel.fromJson,
  );

  Future<StandingsModel> constructors() => fetchAndParse(
    load: () => ApiLoader.get('current/constructorStandings'),
    parse: StandingsModel.fromJson,
  );
}
