import 'package:f1_pet_project/common/career/loaders/career_loader_helper.dart';
import 'package:f1_pet_project/common/career/models/career_race_result.dart';
import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';

/// Загрузка карьерной статистики пилота через Jolpica/Ergast.
abstract class DriverCareerLoader {
  /// Totals + списки побед/подиумов/поулов + команды. [current] — из standings.
  ///
  /// Счётчики из `MRData.total`; списки — пагинация (API max 100/страница).
  static Future<CareerStats<ConstructorModel>> loadData({
    required String driverId,
    List<ConstructorModel> current = const [],
  }) async {
    final prefix = 'drivers/$driverId';

    final totals = await CareerLoaderHelper.getThrottled([
      '$prefix/results',
      '$prefix/results/1',
      '$prefix/results/2',
      '$prefix/results/3',
      '$prefix/qualifying/1',
      '$prefix/constructors',
    ], limit: 1);

    final winPages = await CareerLoaderHelper.fetchAllPages('$prefix/results/1');
    final secondPages = await CareerLoaderHelper.fetchAllPages('$prefix/results/2');
    final thirdPages = await CareerLoaderHelper.fetchAllPages('$prefix/results/3');
    final polePages = await CareerLoaderHelper.fetchAllPages('$prefix/qualifying/1');

    final races = CareerLoaderHelper.totalOf(totals[0]);
    final wins = CareerLoaderHelper.totalOf(totals[1]);
    final second = CareerLoaderHelper.totalOf(totals[2]);
    final third = CareerLoaderHelper.totalOf(totals[3]);
    final poles = CareerLoaderHelper.totalOf(totals[4]);
    final related = CareerLoaderHelper.parseTableEntities(
      response: totals[5],
      tableKey: 'ConstructorTable',
      listKey: 'Constructors',
      fromJson: ConstructorModel.fromJson,
    );

    final winRaces = _parseAll(winPages, position: 1)..sort(_compareNewestFirst);
    final podiumRaces = [
      ...winRaces,
      ..._parseAll(secondPages, position: 2),
      ..._parseAll(thirdPages, position: 3),
    ]..sort(_compareNewestFirst);
    final poleRaces = _parseAllPoles(polePages)..sort(_compareNewestFirst);

    return CareerStats(
      races: races,
      wins: wins,
      podiums: wins + second + third,
      poles: poles,
      current: current,
      related: related,
      winRaces: winRaces,
      podiumRaces: podiumRaces,
      poleRaces: poleRaces,
    );
  }

  static List<CareerRaceResult> _parseAll(List<BaseResponseModel> pages, {required int position}) {
    return [for (final page in pages) ..._parseRaceResults(page, position: position)];
  }

  static List<CareerRaceResult> _parseAllPoles(List<BaseResponseModel> pages) {
    return [for (final page in pages) ..._parseQualifyingPoles(page)];
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
        results.add(
          CareerRaceResult(
            season: race.season,
            round: race.round,
            raceName: race.raceName,
            position: position,
            constructor: entry.first.constructor,
            circuit: race.circuit,
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
        results.add(
          CareerRaceResult(
            season: race.season,
            round: race.round,
            raceName: race.raceName,
            position: 1,
            constructor: entry.first.constructor,
            circuit: race.circuit,
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
