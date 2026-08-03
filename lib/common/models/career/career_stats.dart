import 'package:f1_pet_project/common/models/career/career_race_result.dart';

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
    this.listsComplete = true,
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

  /// `false`, пока пагинированные списки гонок ещё грузятся.
  final bool listsComplete;

  CareerStats<T> copyWith({
    int? races,
    int? wins,
    int? podiums,
    int? poles,
    List<T>? current,
    List<T>? related,
    List<CareerRaceResult>? winRaces,
    List<CareerRaceResult>? podiumRaces,
    List<CareerRaceResult>? poleRaces,
    bool? listsComplete,
  }) {
    return CareerStats(
      races: races ?? this.races,
      wins: wins ?? this.wins,
      podiums: podiums ?? this.podiums,
      poles: poles ?? this.poles,
      current: current ?? this.current,
      related: related ?? this.related,
      winRaces: winRaces ?? this.winRaces,
      podiumRaces: podiumRaces ?? this.podiumRaces,
      poleRaces: poleRaces ?? this.poleRaces,
      listsComplete: listsComplete ?? this.listsComplete,
    );
  }
}
