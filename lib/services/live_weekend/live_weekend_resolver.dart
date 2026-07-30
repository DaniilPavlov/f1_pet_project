import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';

/// Сопоставляет ESPN scoreboard / «сейчас» с гонкой Jolpica из расписания.
abstract final class LiveWeekendResolver {
  /// Предпочитает совпадение по имени трассы; иначе уикенд, в окно которого попадает [now].
  static RacesModel? resolve({
    required List<RacesModel> races,
    EspnScoreboardEvent? scoreboard,
    DateTime? now,
  }) {
    final matchedByCircuit = _matchByCircuit(races, scoreboard);
    if (matchedByCircuit != null) {
      return matchedByCircuit;
    }
    return _matchByWeekendWindow(races, now ?? DateTime.now());
  }

  static RacesModel? _matchByCircuit(List<RacesModel> races, EspnScoreboardEvent? scoreboard) {
    final espnName = scoreboard?.circuitName?.trim().toLowerCase();
    if (espnName == null || espnName.isEmpty) {
      return null;
    }
    for (final race in races) {
      final jolpicaName = race.circuit.circuitName.trim().toLowerCase();
      if (jolpicaName.isEmpty) {
        continue;
      }
      if (jolpicaName == espnName || jolpicaName.contains(espnName) || espnName.contains(jolpicaName)) {
        return race;
      }
    }
    return null;
  }

  static RacesModel? _matchByWeekendWindow(List<RacesModel> races, DateTime now) {
    for (final race in races) {
      final start = RaceDateTimeHelper.weekendStart(race);
      final end = RaceDateTimeHelper.raceLocal(race).add(const Duration(hours: 4));
      if (!now.isBefore(start) && !now.isAfter(end)) {
        return race;
      }
    }
    return null;
  }
}
