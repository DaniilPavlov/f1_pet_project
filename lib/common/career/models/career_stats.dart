import 'package:f1_pet_project/common/career/models/career_race_result.dart';

/// Агрегированная карьерная статистика (totals Jolpica + списки).
class CareerStats<T> {
  const CareerStats({
    required this.races,
    required this.wins,
    required this.podiums,
    required this.poles,
    required this.current,
    required this.related,
    this.winRaces = const [],
    this.podiumRaces = const [],
    this.poleRaces = const [],
  });

  final int races;
  final int wins;
  final int podiums;
  final int poles;

  /// Сущности текущего сезона (`current/...`).
  final List<T> current;

  /// Все связанные сущности за карьеру.
  final List<T> related;

  /// Победы (`results/1`), новые сверху.
  final List<CareerRaceResult> winRaces;

  /// Подиумы (`results/1|2|3`), новые сверху.
  final List<CareerRaceResult> podiumRaces;

  /// Поулы (`qualifying/1`), новые сверху.
  final List<CareerRaceResult> poleRaces;
}
