/// Агрегированная карьерная статистика (totals Jolpica + списки).
class CareerStats<T> {
  const CareerStats({
    required this.races,
    required this.wins,
    required this.podiums,
    required this.poles,
    required this.current,
    required this.related,
  });

  final int races;
  final int wins;
  final int podiums;
  final int poles;

  /// Сущности текущего сезона (`current/...`).
  final List<T> current;

  /// Все связанные сущности за карьеру.
  final List<T> related;
}
