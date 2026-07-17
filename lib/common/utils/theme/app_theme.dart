import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// Цветовая палитра, тени и радиусы приложения.
class AppTheme {
  static const defaultRadius = Radius.circular(12);

  static const black = Color(0xFF333333);
  static const textGray = Color(0xFFB6B6B6);
  static const grayBG = Color(0xFFF6F6F6);
  static const shadowColor = Color(0xFFD7D7D7);
  static const strokeGray = Color(0xFFD8D8D8);
  static const pink = Color(0xffF3B2AE);
  static const white = Color(0xffFFFFFF);
  static const red = Color.fromARGB(255, 225, 39, 30);

  static const defaultShadows = <BoxShadow>[
    BoxShadow(
      color: shadowColor,
      offset: Offset(0, -4),
      blurRadius: 4,
    ),
  ];

  static const defaultShadowsOther = <BoxShadow>[
    BoxShadow(
      color: shadowColor,
      offset: Offset(0, 4),
      blurRadius: 4,
    ),
  ];

  static final defaultBorderRadius = BorderRadius.circular(12);
}

/// Отображает плейсхолдер при загрузке или ошибке [ExtendedImage].
Widget? loadStateChangedFunction(
  ExtendedImageState state, {
  double height = 24,
  double? width,
  PlaceholderType? placeholder,
}) {
  if (state.extendedImageLoadState == LoadState.loading ||
      state.extendedImageLoadState == LoadState.failed) {
    return SizedBox(
      width: width,
      height: height,
      child: placeholder == null
          ? Container(
              color: AppTheme.strokeGray,
            )
          : Image.asset(
              placeholder.asset,
              fit: BoxFit.cover,
            ),
    );
  }

  return null;
}

/// Типы плейсхолдеров для изображений.
enum PlaceholderType {
  type1,
  type2,
  type3,
}

/// Путь к ассету плейсхолдера по типу.
extension PlaceholderExtension on PlaceholderType {
  static const _path = 'assets/';

  String get asset {
    switch (this) {
      case PlaceholderType.type1:
        return '$_path/typ1.png';
      case PlaceholderType.type2:
        return '$_path/typ2.png';
      case PlaceholderType.type3:
        return '$_path/typ3.png';
      }
  }
}
