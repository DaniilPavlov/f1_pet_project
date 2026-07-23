import 'dart:convert';

import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:flutter/services.dart';

/// Загружает curated stats трасс из `assets/data/circuit_stats.json`.
class CircuitStatsRepository {
  CircuitStatsRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/data/circuit_stats.json';

  final AssetBundle _bundle;
  Map<String, CircuitStats>? _cache;

  /// Stats по Jolpica `circuitId`, либо `null`.
  Future<CircuitStats?> of(String circuitId) async {
    final map = await _ensureLoaded();
    return map[circuitId.trim().toLowerCase()];
  }

  Future<Map<String, CircuitStats>> _ensureLoaded() async {
    final cached = _cache;
    if (cached != null) {
      return cached;
    }

    final raw = await _bundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final map = <String, CircuitStats>{};
    for (final entry in decoded.entries) {
      map[entry.key.toLowerCase()] = CircuitStats.fromJson(entry.value as Map<String, dynamic>);
    }
    return _cache = map;
  }
}
