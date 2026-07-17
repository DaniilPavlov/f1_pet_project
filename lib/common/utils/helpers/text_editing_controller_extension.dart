import 'package:flutter/material.dart';

/// Расширение [TextEditingController] для валидации ввода.
extension TextEditingControllerX on TextEditingController {
  /// Проверяет, что введён четырёхзначный год.
  bool get isValidYear => text.length == 4;
}
