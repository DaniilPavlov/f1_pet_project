import 'package:f1_pet_project/common/utils/country_flag_codes.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Флаг страны/национальности Jolpica (эмодзи). Если код неизвестен — исходный текст.
class CountryFlag extends StatelessWidget {
  const CountryFlag({
    required this.countryOrNationality,
    this.fontSize = 22,
    this.fallbackStyle,
    this.showFallbackText = true,
    super.key,
  });

  final String? countryOrNationality;
  final double fontSize;
  final TextStyle? fallbackStyle;
  final bool showFallbackText;

  @override
  Widget build(BuildContext context) {
    final raw = countryOrNationality?.trim() ?? '';
    final code = CountryFlagCodes.resolve(raw);
    if (code != null) {
      final emoji = CountryFlagCodes.toEmoji(code);
      return Semantics(
        label: raw.isEmpty ? code : raw,
        child: Text(emoji, style: TextStyle(fontSize: fontSize, height: 1)),
      );
    }

    if (!showFallbackText || raw.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      raw,
      style: fallbackStyle ?? AppStyles.caption.copyWith(color: AppTheme.textGray),
      textAlign: TextAlign.center,
    );
  }
}
