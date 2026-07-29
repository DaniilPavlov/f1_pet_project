import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('copyWith overrides selected fields', () {
      final copied = AppColors.light.copyWith(red: Colors.blue, black: Colors.green);
      expect(copied.red, Colors.blue);
      expect(copied.black, Colors.green);
      expect(copied.white, AppColors.light.white);

      final keep = AppColors.light.copyWith(textGray: Colors.grey);
      expect(keep.black, AppColors.light.black);
      expect(keep.red, AppColors.light.red);
      expect(keep.textGray, Colors.grey);
    });

    test('lerp blends toward other palette', () {
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);
      expect(mid.black, Color.lerp(AppColors.light.black, AppColors.dark.black, 0.5));
      expect(AppColors.light.lerp(null, 0.5), same(AppColors.light));
    });

    testWidgets('context.colors falls back to light without extension', (tester) async {
      late AppColors colors;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              colors = context.colors;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(colors.red, AppColors.light.red);
    });

    testWidgets('context.colors reads ThemeExtension', (tester) async {
      late AppColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppColors.dark]),
          home: Builder(
            builder: (context) {
              colors = context.colors;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(colors.white, AppColors.dark.white);
    });
  });

  group('AppThemeData', () {
    test('dark theme builds', () {
      final theme = AppThemeData.dark();
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });
  });
}
