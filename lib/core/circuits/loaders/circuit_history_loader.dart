import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// История побед на трассе через Jolpica.
abstract class CircuitHistoryLoader {
  /// Победители ГП на трассе (новые сверху). Один запрос, limit=100.
  static Future<List<CircuitRaceWin>> loadWinners({required String circuitId}) async {
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

    // API отдаёт по возрастанию сезона.
    return wins.reversed.toList(growable: false);
  }
}
