import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';

/// H2H-метрики пилотов и конструкторов.
///
/// Compare грузит results (+ sprint) один раз на участника и считает wins/podiums
/// из тех же страниц; poles — отдельный лёгкий запрос `limit=1`.
class H2hRepository {
  const H2hRepository();

  Future<H2hStats> driverStats({required String driverId, String? season}) async {
    final data = await loadDriverCompareData(driverId: driverId, season: season);
    return data.stats;
  }

  Future<H2hStats> constructorStats({required String constructorId, String? season}) async {
    final data = await loadConstructorCompareData(constructorId: constructorId, season: season);
    return data.stats;
  }

  Future<List<H2hRoundScore>> driverRoundScores({required String driverId, String? season}) async {
    final data = await loadDriverCompareData(driverId: driverId, season: season);
    return data.scores;
  }

  Future<List<H2hRoundScore>> constructorRoundScores({
    required String constructorId,
    String? season,
  }) async {
    final data = await loadConstructorCompareData(constructorId: constructorId, season: season);
    return data.scores;
  }

  /// Stats + timeline scores за один проход (results → sprint → poles).
  Future<H2hEntityCompareData> loadDriverCompareData({
    required String driverId,
    String? season,
  }) => _loadEntityCompareData(entityPath: 'drivers/$driverId', season: season);

  Future<H2hEntityCompareData> loadConstructorCompareData({
    required String constructorId,
    String? season,
  }) => _loadEntityCompareData(entityPath: 'constructors/$constructorId', season: season);

  /// Два участника подряд (глобальный throttle сериализует все GET).
  Future<H2hLoadedCompare> compareDrivers({
    required String driverIdA,
    required String driverIdB,
    String? season,
  }) async {
    final a = await loadDriverCompareData(driverId: driverIdA, season: season);
    final b = await loadDriverCompareData(driverId: driverIdB, season: season);
    return H2hLoadedCompare(
      statsA: a.stats,
      statsB: b.stats,
      timeline: H2hPointsTimeline.fromScores(
        scoresA: a.scores,
        scoresB: b.scores,
        seasonScope: season,
      ),
    );
  }

  Future<H2hLoadedCompare> compareConstructors({
    required String constructorIdA,
    required String constructorIdB,
    String? season,
  }) async {
    final a = await loadConstructorCompareData(constructorId: constructorIdA, season: season);
    final b = await loadConstructorCompareData(constructorId: constructorIdB, season: season);
    return H2hLoadedCompare(
      statsA: a.stats,
      statsB: b.stats,
      timeline: H2hPointsTimeline.fromScores(
        scoresA: a.scores,
        scoresB: b.scores,
        seasonScope: season,
      ),
    );
  }

  Future<H2hEntityCompareData> _loadEntityCompareData({
    required String entityPath,
    String? season,
  }) async {
    final prefix = _prefix(season);
    final racePages = await CareerApiHelper.fetchAllPages('$prefix$entityPath/results');
    final sprintPages = await CareerApiHelper.fetchAllPages('$prefix$entityPath/sprint');
    final polesResponse = await CareerApiHelper.getThrottled([
      '$prefix$entityPath/qualifying/1',
    ], limit: 1);

    final byKey = <String, H2hRoundScore>{};
    var wins = 0;
    var seconds = 0;
    var thirds = 0;
    final raceKeys = <String>{};

    void mergeRacePages(List<BaseResponseModel> pages, {required bool sprint}) {
      for (final page in pages) {
        try {
          final schedule = ScheduleModel.fromJson(Map<String, dynamic>.from(page.mrData as Map));
          for (final race in schedule.raceTable.races) {
            final entries = sprint ? race.sprintResults : race.results;
            if (entries == null || entries.isEmpty) {
              continue;
            }
            final key = '${race.season}-${race.round}';
            if (!sprint) {
              raceKeys.add(key);
            }
            var points = 0.0;
            for (final entry in entries) {
              points += double.tryParse(entry.points) ?? 0;
              if (!sprint) {
                final pos = int.tryParse(entry.position);
                if (pos == 1) {
                  wins++;
                } else if (pos == 2) {
                  seconds++;
                } else if (pos == 3) {
                  thirds++;
                }
              }
            }
            final prev = byKey[key];
            byKey[key] = H2hRoundScore(
              season: race.season,
              round: race.round,
              raceName: race.raceName,
              points: (prev?.points ?? 0) + points,
            );
          }
        } on Object {
          // skip broken page
        }
      }
    }

    mergeRacePages(racePages, sprint: false);
    mergeRacePages(sprintPages, sprint: true);

    final scores = byKey.values.toList()
      ..sort((a, b) {
        final seasonCmp = a.season.compareTo(b.season);
        if (seasonCmp != 0) {
          return seasonCmp;
        }
        return a.roundNumber.compareTo(b.roundNumber);
      });

    return H2hEntityCompareData(
      stats: H2hStats(
        races: raceKeys.length,
        wins: wins,
        podiums: wins + seconds + thirds,
        poles: CareerApiHelper.totalOf(polesResponse.first),
      ),
      scores: List.unmodifiable(scores),
    );
  }

  String _prefix(String? season) {
    if (season == null || season.trim().isEmpty) {
      return '';
    }
    return '${season.trim()}/';
  }
}
