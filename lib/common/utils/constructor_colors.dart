import 'package:flutter/material.dart';

/// Цвета команд (constructors) и связанных с ними пилотов.
///
/// Ключ — Jolpica `constructorId`. Неизвестные команды получают стабильный
/// цвет из fallback-палитры по хэшу id.
abstract final class ConstructorColors {
  /// Известные Jolpica `constructorId` → цвет команды.
  static const knownByConstructorId = <String, Color>{
    'ferrari': Color(0xFF8B0000), // тёмно-красный
    'mercedes': Color(0xFF006F62), // тёмно-зелёный
    'red_bull': Color(0xFF1E2E5A), // тёмно-синий
    'rb': Color(0xFF6B9AC4), // светло-синий
    'racing_bulls': Color(0xFF6B9AC4),
    'mclaren': Color(0xFFFF8700), // оранжевый
    'audi': Color(0xFFE85A5A), // светло-красный
    'sauber': Color(0xFFE85A5A),
    'kick_sauber': Color(0xFFE85A5A),
    'cadillac': Color(0xFF8A8D8F), // серый
    'haas': Color(0xFF2B2B2B), // чёрный (читаемый на grayBG)
    'aston_martin': Color(0xFF229971), // зелёный
    'alpine': Color(0xFFFF69B4), // розовый
    'williams': Color(0xFF00A0DE), // синий
  };

  /// Fallback-палитра для остальных команд.
  static const _fallbackSwatches = <Color>[
    Color(0xFF3671C6),
    Color(0xFF27F4D2),
    Color(0xFF52E252),
    Color(0xFFFE5888),
    Color(0xFF64C4FF),
    Color(0xFFA19D94),
    Color(0xFF9B59B6),
    Color(0xFFF1C40F),
  ];

  /// Цвет команды по `constructorId` (известный или hash-fallback).
  static Color forConstructorId(String constructorId) {
    final key = constructorId.trim().toLowerCase();
    final known = knownByConstructorId[key];
    if (known != null) {
      return known;
    }
    final hash = key.codeUnits.fold<int>(0, (acc, c) => (acc * 31 + c) & 0x7fffffff);
    return _fallbackSwatches[hash % _fallbackSwatches.length];
  }
}
