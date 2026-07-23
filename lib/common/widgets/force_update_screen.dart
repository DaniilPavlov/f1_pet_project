import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Блокирующий экран: версия ниже минимума из Remote Config.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: StaticData.defaultVerticalPadding,
            horizontal: StaticData.defaultHorizontalPadding,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Observer(
                  builder: (context) {
                    return GestureDetector(
                      onTap: localeController.toggle,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          localeController.localeCodeLabel,
                          style: AppStyles.body.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 4,
                        right: MediaQuery.of(context).size.width / 4,
                        bottom: 10,
                      ),
                      child: Image.asset(
                        'assets/error_car.png',
                        height: MediaQuery.of(context).size.height / 3.6,
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.forceUpdateTitle,
                        maxLines: 3,
                        style: AppStyles.h2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 20, left: 20, right: 20),
                      child: Text(
                        context.l10n.forceUpdateSubtitle,
                        style: AppStyles.h3,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: BlackButton(
                        haveShadow: true,
                        onTap: () => Utils.openUrl(
                          rawUrl: StaticData.githubReleasesUrl,
                          externalApplication: true,
                        ),
                        text: context.l10n.forceUpdateButton,
                        isDisabled: false,
                      ),
                    ),
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
