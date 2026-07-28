import 'package:flutter/material.dart';

/// Бренд-хром и структурные токены (не зависят от light/dark).
///
/// Контентные цвета — через [AppColors] / `context.colors`.
abstract final class AppTheme {
  static const defaultRadius = Radius.circular(12);

  /// App bar, nav bar, primary filled buttons.
  static const chrome = Color(0xFF333333);

  /// Текст/иконки на [chrome] и на brand-red.
  static const onChrome = Color(0xFFFFFFFF);

  /// Брендовый F1-красный (одинаков в light/dark).
  static const red = Color.fromARGB(255, 225, 39, 30);

  /// Приглушённый акцент.
  static const pink = Color(0xFFF3B2AE);

  static final defaultBorderRadius = BorderRadius.circular(12);
}
