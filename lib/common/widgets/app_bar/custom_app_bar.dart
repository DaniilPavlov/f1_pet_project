import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/buttons/circle_button.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Кастомный AppBar с логотипом или заголовком и кнопкой «назад».
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({this.title, this.onPop, super.key});
  final String? title;

  final VoidCallback? onPop;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();

    return ColorfulSafeArea(
      color: AppTheme.black,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.black,
          boxShadow: [
            BoxShadow(color: AppTheme.black.withValues(alpha: 0.5), blurRadius: 8, blurStyle: BlurStyle.outer),
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
                  if (onPop != null)
                    CircleButton(
                      child: Transform.translate(
                        offset: const Offset(-1, 0),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                      ),
                      onPressed: () {
                        if (context.router.canPop()) {
                          onPop?.call();
                        }
                      },
                    ),
                ],
              ),
              Center(
                child: title != null
                    ? Text(title!, style: AppStyles.body.copyWith(color: AppTheme.white))
                    : Image.asset('assets/app_logo.png'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Observer(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () async {
                        await localeController.toggle();
                        if (!context.mounted) {
                          return;
                        }
                        unawaited(
                          context.read<RaceReminderService>().sync(locale: localeController.locale),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          localeController.localeCodeLabel,
                          style: AppStyles.body.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
