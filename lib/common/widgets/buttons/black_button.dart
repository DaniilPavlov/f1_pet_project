import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';

/// Основная кнопка действия приложения (chrome / светлая в dark).
class BlackButton extends StatelessWidget {
  const BlackButton({
    required this.onTap,
    required this.text,
    required this.isDisabled,
    this.isLoading = false,
    this.haveShadow = false,
    this.leadIcon,
    this.midIcon,
    super.key,
  });
  final Widget? leadIcon;
  final Widget? midIcon;
  final bool haveShadow;
  final VoidCallback onTap;
  final String text;
  final bool isDisabled;

  /// Показывает [CustomLoadingIndicator] вместо текста (pill остаётся).
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final blocked = isDisabled || isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Light: тёмный chrome на белом. Dark: светлая pill на #121212 — иначе
    // chrome ≈ фон и кнопка выглядит «выключенной».
    final fill = isDark ? AppTheme.onChrome : AppTheme.chrome;
    final fillColor = isDisabled && !isLoading ? fill.withValues(alpha: isDark ? 0.35 : 0.3) : fill;
    final labelColor = isDisabled && !isLoading ? AppTheme.red.withValues(alpha: 0.35) : AppTheme.red;

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: blocked ? () {} : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: haveShadow && !blocked
              ? [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    color: isDark ? Colors.black54 : AppTheme.chrome,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: CustomLoadingIndicator(
                    size: 32,
                    onDarkBackground: !isDark,
                  ),
                ),
              )
            else if (leadIcon != null) ...[
              Padding(padding: const EdgeInsets.only(right: 8), child: leadIcon),
              Text(text, style: AppStyles.h3.copyWith(color: labelColor)),
            ] else
              Expanded(
                child: midIcon != null
                    ? midIcon!
                    : Text(
                        text,
                        textAlign: TextAlign.center,
                        style: AppStyles.h3.copyWith(color: labelColor),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
