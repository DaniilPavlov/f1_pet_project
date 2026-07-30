import 'package:flutter/foundation.dart';

/// Одна полоса в racing-chart Season Rewind.
@immutable
class SeasonRewindBarEntry {
  const SeasonRewindBarEntry({
    required this.id,
    required this.constructorId,
    required this.label,
    required this.tag,
    required this.points,
    required this.rank,
  });

  /// Стабильный ключ участника (driverId / constructorId) для анимации.
  final String id;

  /// Команда для цвета полосы (у пилота — текущий constructor).
  final String constructorId;

  /// Основная подпись (фамилия / название команды).
  final String label;

  /// Короткий тег справа от имени (код пилота и т.п.).
  final String tag;

  final double points;

  /// 0-based позиция (дробная во время lerp-анимации).
  final double rank;

  SeasonRewindBarEntry copyWith({
    String? id,
    String? constructorId,
    String? label,
    String? tag,
    double? points,
    double? rank,
  }) {
    return SeasonRewindBarEntry(
      id: id ?? this.id,
      constructorId: constructorId ?? this.constructorId,
      label: label ?? this.label,
      tag: tag ?? this.tag,
      points: points ?? this.points,
      rank: rank ?? this.rank,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonRewindBarEntry &&
          id == other.id &&
          constructorId == other.constructorId &&
          label == other.label &&
          tag == other.tag &&
          points == other.points &&
          rank == other.rank;

  @override
  int get hashCode => Object.hash(id, constructorId, label, tag, points, rank);
}
