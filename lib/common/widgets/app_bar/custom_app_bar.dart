import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/common/widgets/buttons/circle_button.dart';
import 'package:f1_pet_project/core/profile/controllers/notifications_preference_controller/notifications_preference_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Кастомный AppBar с логотипом или заголовком и кнопкой «назад».
///
/// Кнопка назад показывается, если передан [onPop] или стек можно pop
/// ([Navigator.canPop]) — чтобы вложенные экраны не забывали про back.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({this.title, this.onPop, this.onShare, this.showPreferences = false, super.key});
  final String? title;

  final VoidCallback? onPop;

  /// Кнопка шаринга слева от переключателя темы/языка.
  final VoidCallback? onShare;
  final bool showPreferences;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  bool _shouldShowBack(BuildContext context) {
    if (onPop != null) {
      return true;
    }
    return Navigator.of(context).canPop();
  }

  void _handlePop(BuildContext context) {
    if (onPop != null) {
      onPop!();
      return;
    }
    if (context.router.canPop()) {
      context.router.maybePop();
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();
    final themeController = context.read<ThemeController>();
    final showBack = _shouldShowBack(context);

    return ColorfulSafeArea(
      color: AppTheme.chrome,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.chrome,
          boxShadow: [
            BoxShadow(color: AppTheme.chrome.withValues(alpha: 0.5), blurRadius: 8, blurStyle: BlurStyle.outer),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: StaticData.defaultHorizontalPadding,
            left: StaticData.defaultHorizontalPadding,
            top: 16,
            bottom: 12,
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBack)
                    CircleButton(
                      child: Transform.translate(
                        offset: const Offset(-1, 0),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.onChrome),
                      ),
                      onPressed: () => _handlePop(context),
                    ),
                ],
              ),
              Center(
                child: title != null
                    ? Text(title!, style: AppStyles.body.copyWith(color: AppTheme.onChrome))
                    : Image.asset(Assets.appLogo),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onShare != null) ...[
                      CircleButton(
                        onPressed: onShare,
                        child: const Icon(Icons.ios_share, size: 18, color: AppTheme.onChrome),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (showPreferences) ...[
                      Observer(
                        builder: (context) {
                          return GestureDetector(
                            onTap: themeController.cycle,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Icon(
                                themeController.preferenceIcon,
                                size: 20,
                                color: AppTheme.onChrome,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Observer(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () async {
                              await localeController.toggle();
                              if (!context.mounted) {
                                return;
                              }
                              unawaited(
                                context.read<NotificationsPreferenceController>().resync(
                                  locale: localeController.locale,
                                ),
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Text(
                                localeController.localeCodeLabel,
                                style: AppStyles.body.copyWith(
                                  color: AppTheme.onChrome,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
