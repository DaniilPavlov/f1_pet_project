import 'package:f1_pet_project/common/career/loaders/career_loader_helper.dart';
import 'package:f1_pet_project/common/career/models/career_race_result.dart';
import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';

/// Карьера конструктора (Jolpica).
class ConstructorCareerRepository {
  const ConstructorCareerRepository();

  /// Totals + полные списки побед/подиумов/поулов + пилоты. [current] — из standings.
  ///
  /// Jolpica режет страницу до 100 — счётчики берутся из `MRData.total`,
  /// списки собираются пагинацией.
  Future<CareerStats<DriverModel>> load({
    required String constructorId,
    List<DriverModel> current = const [],
  }) async {
    final prefix = 'constructors/$constructorId';

    final allResultsPages = await CareerLoaderHelper.fetchAllPages('$prefix/results');
    final winPages = await CareerLoaderHelper.fetchAllPages('$prefix/results/1');
    final secondPages = await CareerLoaderHelper.fetchAllPages('$prefix/results/2');
    final thirdPages = await CareerLoaderHelper.fetchAllPages('$prefix/results/3');
    final polePages = await CareerLoaderHelper.fetchAllPages('$prefix/qualifying/1');

    final driversResponse = (await CareerLoaderHelper.getThrottled(['$prefix/drivers'])).first;

    final winRaces = _parseAllRaceResults(winPages, position: 1)..sort(_compareNewestFirst);
    final podiumRaces = CareerLoaderHelper.dedupeByBestPosition([
      ...winRaces,
      ..._parseAllRaceResults(secondPages, position: 2),
      ..._parseAllRaceResults(thirdPages, position: 3),
    ])..sort(_compareNewestFirst);
    final poleRaces = _parseAllQualifyingPoles(polePages)..sort(_compareNewestFirst);

    final races = CareerLoaderHelper.uniqueRaceCountAcross(allResultsPages);
    final winsTotal = winPages.isEmpty ? 0 : CareerLoaderHelper.totalOf(winPages.first);
    final polesTotal = polePages.isEmpty ? 0 : CareerLoaderHelper.totalOf(polePages.first);

    final related = CareerLoaderHelper.parseTableEntities(
      response: driversResponse,
      tableKey: 'DriverTable',
      listKey: 'Drivers',
      fromJson: DriverModel.fromJson,
    );

    return CareerStats(
      races: races > 0 ? races : (allResultsPages.isEmpty ? 0 : CareerLoaderHelper.totalOf(allResultsPages.first)),
      wins: winsTotal > 0 ? winsTotal : winRaces.length,
      podiums: podiumRaces.length,
      poles: polesTotal > 0 ? polesTotal : poleRaces.length,
      current: current,
      related: related,
      winRaces: winRaces,
      podiumRaces: podiumRaces,
      poleRaces: poleRaces,
    );
  }

  static List<CareerRaceResult> _parseAllRaceResults(
    List<BaseResponseModel> pages, {
    required int position,
  }) {
    final results = <CareerRaceResult>[];
    for (final page in pages) {
      results.addAll(_parseRaceResults(page, position: position));
    }
    return results;
  }

  static List<CareerRaceResult> _parseAllQualifyingPoles(List<BaseResponseModel> pages) {
    final results = <CareerRaceResult>[];
    for (final page in pages) {
      results.addAll(_parseQualifyingPoles(page));
    }
    return results;
  }

  static List<CareerRaceResult> _parseRaceResults(
    BaseResponseModel response, {
    required int position,
  }) {
    try {
      final schedule = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
      final results = <CareerRaceResult>[];
      for (final race in schedule.raceTable.races) {
        final entry = race.results;
        if (entry == null || entry.isEmpty) {
          continue;
        }
        final first = entry.first;
        results.add(
          CareerRaceResult(
            season: race.season,
            round: race.round,
            raceName: race.raceName,
            position: position,
            constructor: first.constructor,
            circuit: race.circuit,
            driver: first.driver,
          ),
        );
      }
      return results;
    } on Object {
      return const [];
    }
  }

  static List<CareerRaceResult> _parseQualifyingPoles(BaseResponseModel response) {
    try {
      final schedule = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
      final results = <CareerRaceResult>[];
      for (final race in schedule.raceTable.races) {
        final entry = race.qualifyingResults;
        if (entry == null || entry.isEmpty) {
          continue;
        }
        final first = entry.first;
        results.add(
          CareerRaceResult(
            season: race.season,
            round: race.round,
            raceName: race.raceName,
            position: 1,
            constructor: first.constructor,
            circuit: race.circuit,
            driver: first.driver,
          ),
        );
      }
      return results;
    } on Object {
      return const [];
    }
  }

  static int _compareNewestFirst(CareerRaceResult a, CareerRaceResult b) {
    final seasonCmp = b.season.compareTo(a.season);
    if (seasonCmp != 0) {
      return seasonCmp;
    }
    return b.round.compareTo(a.round);
  }
}
