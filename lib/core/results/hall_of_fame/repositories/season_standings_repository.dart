import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Standings за сезон (финал) или после конкретного раунда.
class SeasonStandingsRepository {
  const SeasonStandingsRepository();

  Future<StandingsModel> drivers({required String year, String? round}) => fetchAndParse(
    load: () => ApiLoader.get(_standingsPath(year: year, round: round, kind: 'driverStandings')),
    parse: StandingsModel.fromJson,
  );

  Future<StandingsModel> constructors({required String year, String? round}) => fetchAndParse(
    load: () => ApiLoader.get(_standingsPath(year: year, round: round, kind: 'constructorStandings')),
    parse: StandingsModel.fromJson,
  );

  static String _standingsPath({
    required String year,
    required String? round,
    required String kind,
  }) {
    if (round == null || round.isEmpty) {
      return '$year/$kind';
    }
    return '$year/$round/$kind';
  }
}
