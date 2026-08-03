import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';

/// Какая сетка сейчас редактируется.
enum PredictorGridKind { qualifying, race }

/// Пилот с реальным трёхбуквенным кодом (не пустой и не `none`).
bool hasUsableDriverCode(DriverModel driver) {
  final code = driver.code?.trim();
  return code != null && code.isNotEmpty && code.toLowerCase() != 'none';
}

/// Стартовый порядок предикта: места в чемпионате, затем остальные из ростера.
List<String> defaultPredictorOrder({
  required List<String> rosterIds,
  required List<String> championshipOrder,
}) {
  if (championshipOrder.isEmpty) {
    return List<String>.from(rosterIds);
  }
  final rosterSet = rosterIds.toSet();
  final ranked = championshipOrder.where(rosterSet.contains).toList();
  final missing = rosterIds.where((id) => !ranked.contains(id));
  return [...ranked, ...missing];
}

/// Сохраняет порядок [saved], подмешивая отсутствующих из [rosterIds] в конец.
List<String> syncOrderToRoster(List<String> saved, List<String> rosterIds) {
  final rosterSet = rosterIds.toSet();
  final kept = saved.where(rosterSet.contains).toList();
  final missing = rosterIds.where((id) => !kept.contains(id));
  return [...kept, ...missing];
}
