/// Очки участника за один раунд (гонка + спринт, если есть).
class H2hRoundScore {
  const H2hRoundScore({
    required this.season,
    required this.round,
    required this.raceName,
    required this.points,
  });

  final String season;
  final String round;
  final String raceName;
  final double points;

  String get key => '$season-$round';

  int get roundNumber => int.tryParse(round) ?? 0;
}
