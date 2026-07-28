import 'package:flutter/material.dart';

/// Семантическая палитра приложения как [ThemeExtension].
///
/// В виджетах: `context.colors.*`. Для шаринга/фиксированного light —
/// [AppColors.light]. Хром (app bar / nav) — [AppTheme.chrome].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.black,
    required this.textGray,
    required this.grayBG,
    required this.shadowColor,
    required this.strokeGray,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.pink,
    required this.white,
    required this.red,
  });

  /// Основной текст / ink на фоне [white].
  final Color black;

  /// Вторичный текст.
  final Color textGray;

  /// Поверхность (zebra-rows, карточки).
  final Color grayBG;

  final Color shadowColor;
  final Color strokeGray;
  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Приглушённый акцент (неактивные табы).
  final Color pink;

  /// Фон scaffold / «белая» поверхность.
  final Color white;

  /// Брендовый F1-красный.
  final Color red;

  static const light = AppColors(
    black: Color(0xFF333333),
    textGray: Color(0xFFB6B6B6),
    grayBG: Color(0xFFF6F6F6),
    shadowColor: Color(0xFFD7D7D7),
    strokeGray: Color(0xFFD8D8D8),
    shimmerBase: Color(0xFFC8C8C8),
    shimmerHighlight: Color(0xFFE0E0E0),
    pink: Color(0xFFF3B2AE),
    white: Color(0xFFFFFFFF),
    red: Color.fromARGB(255, 225, 39, 30),
  );

  static const dark = AppColors(
    black: Color(0xFFE8E8E8),
    textGray: Color(0xFF9A9A9A),
    grayBG: Color(0xFF1E1E1E),
    shadowColor: Color(0xFF000000),
    strokeGray: Color(0xFF3A3A3A),
    shimmerBase: Color(0xFF2C2C2C),
    shimmerHighlight: Color(0xFF404040),
    pink: Color(0xFFC48B87),
    white: Color(0xFF121212),
    red: Color.fromARGB(255, 225, 39, 30),
  );

  @override
  AppColors copyWith({
    Color? black,
    Color? textGray,
    Color? grayBG,
    Color? shadowColor,
    Color? strokeGray,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? pink,
    Color? white,
    Color? red,
  }) {
    return AppColors(
      black: black ?? this.black,
      textGray: textGray ?? this.textGray,
      grayBG: grayBG ?? this.grayBG,
      shadowColor: shadowColor ?? this.shadowColor,
      strokeGray: strokeGray ?? this.strokeGray,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      pink: pink ?? this.pink,
      white: white ?? this.white,
      red: red ?? this.red,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      black: Color.lerp(black, other.black, t)!,
      textGray: Color.lerp(textGray, other.textGray, t)!,
      grayBG: Color.lerp(grayBG, other.grayBG, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      strokeGray: Color.lerp(strokeGray, other.strokeGray, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      white: Color.lerp(white, other.white, t)!,
      red: Color.lerp(red, other.red, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
