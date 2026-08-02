import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';

/// Policy: блокировка правок предиктора (за час до основной квалификации).
abstract final class PredictorLock {
  static const lead = Duration(hours: 1);

  /// Момент блокировки; `null` если нет времени quali → правки разрешены.
  static DateTime? lockAt(RacesModel race) {
    final qualifying = race.qualifying;
    if (qualifying == null) {
      return null;
    }
    return RaceDateTimeHelper.toLocal(qualifying).subtract(lead);
  }

  /// Правки запрещены, когда `now >= lockAt`. Без quali time — не locked.
  static bool isLocked(RacesModel race, DateTime now) {
    final at = lockAt(race);
    if (at == null) {
      return false;
    }
    return !now.isBefore(at);
  }
}
