import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Трассы Jolpica: список и история побед.
class CircuitsRepository {
  const CircuitsRepository();

  Future<CircuitsModel> all() => fetchAndParse(load: () => ApiLoader.get('circuits'), parse: CircuitsModel.fromJson);

  /// Ищет трассу по stable id (Jolpica/Ergast circuitId).
  ///
  /// Используется для deep link'ов вида `f1pet://circuit/<circuitId>`.
  Future<CircuitModel?> findByCircuitId(String circuitId) async {
    final id = circuitId.trim();
    if (id.isEmpty) {
      return null;
    }

    try {
      final response = await fetchAndParse(
        load: () => ApiLoader.get('circuits/$id', limit: 1),
        parse: CircuitsModel.fromJson,
      );
      final circuits = response.circuitTable.circuits;
      return circuits.isEmpty ? null : circuits.first;
    } on Object catch (error, stackTrace) {
      logger.e('CircuitsRepository.byCircuitId failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// Победители ГП на трассе (новые сверху).
  Future<List<CircuitRaceWin>> winners({required String circuitId}) async {
    final response = await ApiLoader.get('circuits/$circuitId/results/1');
    final schedule = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
    final wins = <CircuitRaceWin>[];

    for (final race in schedule.raceTable.races) {
      final results = race.results;
      if (results == null || results.isEmpty) {
        continue;
      }
      final winner = results.first;
      wins.add(
        CircuitRaceWin(
          season: race.season,
          round: race.round,
          raceName: race.raceName,
          driver: winner.driver,
          constructor: winner.constructor,
        ),
      );
    }

    return wins.reversed.toList(growable: false);
  }
}
