import 'package:flutter/material.dart';

/// Текстовые стили приложения: заголовки, body и подписи.
///
/// Цвет не задан — наследуется из [DefaultTextStyle] / [ThemeData.textTheme]
/// или задаётся через `copyWith(color: ...)`.
abstract final class AppStyles {
  static const h1 = TextStyle(fontFamily: 'HelveticaNeueCyr-Bold', fontSize: 34, height: 34 / 34);

  static const h2 = TextStyle(fontFamily: 'HelveticaNeueCyr-Bold', fontSize: 30, height: 30 / 30);

  static const h3 = TextStyle(
    fontFamily: 'HelveticaNeueCyr-Bold',
    fontSize: 25,
    height: 25 / 25,
    letterSpacing: -0.01,
  );

  static const body = TextStyle(fontFamily: 'Inter-Regular', fontSize: 16, height: 20 / 16);

  static const caption = TextStyle(fontFamily: 'Inter-Regular', fontSize: 12, height: 14 / 12);

  static const navBar = TextStyle(fontFamily: 'Inter-Regular', fontSize: 10, height: 12 / 10);
}
