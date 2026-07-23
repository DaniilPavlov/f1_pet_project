/// Метрики для сравнения H2H (пилот или конструктор).
class H2hStats {
  const H2hStats({
    required this.races,
    required this.wins,
    required this.podiums,
    required this.poles,
  });

  final int races;
  final int wins;
  final int podiums;
  final int poles;
}
