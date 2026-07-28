import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Сборка [ThemeData] light/dark.
abstract final class AppThemeData {
  static ThemeData light() => _build(brightness: Brightness.light, colors: AppColors.light);

  static ThemeData dark() => _build(brightness: Brightness.dark, colors: AppColors.dark);

  static ThemeData _build({required Brightness brightness, required AppColors colors}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors.red,
      brightness: brightness,
    ).copyWith(
      primary: colors.red,
      onPrimary: AppTheme.onChrome,
      surface: colors.white,
      onSurface: colors.black,
      onSurfaceVariant: colors.textGray,
      outline: colors.strokeGray,
      outlineVariant: colors.strokeGray,
      error: colors.red,
    );

    final textTheme = TextTheme(
      displayLarge: AppStyles.h1.copyWith(color: colors.black),
      displayMedium: AppStyles.h2.copyWith(color: colors.black),
      displaySmall: AppStyles.h3.copyWith(color: colors.black),
      bodyLarge: AppStyles.body.copyWith(color: colors.black),
      bodyMedium: AppStyles.body.copyWith(color: colors.black),
      bodySmall: AppStyles.caption.copyWith(color: colors.black),
      labelSmall: AppStyles.navBar.copyWith(color: colors.black),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.white,
      canvasColor: colors.white,
      dividerColor: colors.strokeGray,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: colors.black),
      primaryIconTheme: const IconThemeData(color: AppTheme.onChrome),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.chrome,
        foregroundColor: AppTheme.onChrome,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.red),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.red,
        foregroundColor: AppTheme.onChrome,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.chrome,
        contentTextStyle: AppStyles.body.copyWith(color: AppTheme.onChrome),
      ),
      extensions: [colors],
    );
  }
}
