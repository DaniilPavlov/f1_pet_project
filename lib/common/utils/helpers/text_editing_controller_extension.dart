import 'package:flutter/material.dart';

/// Расширение [TextEditingController] для валидации ввода.
extension TextEditingControllerX on TextEditingController {
  static const minF1Year = 1950;
  static const maxF1Year = 2030;
  static const maxRaceRound = 99;

  /// Четырёхзначный год F1 в допустимом диапазоне.
  bool get isValidYear {
    if (text.length != 4) {
      return false;
    }
    final year = int.tryParse(text);
    if (year == null) {
      return false;
    }
    return year >= minF1Year && year <= maxF1Year;
  }

  /// Номер гонки в сезоне: 1–99.
  bool get isValidRound {
    if (text.isEmpty) {
      return false;
    }
    final round = int.tryParse(text);
    if (round == null) {
      return false;
    }
    return round >= 1 && round <= maxRaceRound;
  }
}
