import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_tables_section.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/hall_of_fame/controllers/hall_of_fame_screen_controller/hall_of_fame_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран «Зал славы» с турнирными таблицами за выбранный сезон.
@RoutePage()
class HallOfFameScreen extends StatelessWidget {
  const HallOfFameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HallOfFameScreenController>(
      create: (_) => HallOfFameScreenController()..loadAllData(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<HallOfFameScreenController>();
              if (controller.driversStandings.isLoading || controller.constructorsStandings.isLoading) {
                return const CustomLoadingIndicator();
              }
              if (controller.screenError != null) {
                return ErrorBody(
                  onTap: controller.loadAllData,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              final constructors = controller.constructorsStandings.value;
              final drivers = controller.driversStandings.value;

              return CustomScrollView(
                scrollBehavior: AntiGlowBehavior(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: StaticData.defaultHorizontalPadding,
                        vertical: StaticData.defaultVerticalPadding,
                      ),
                      child: Text(context.l10n.hallOfFameTitle, style: AppStyles.h1),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                      child: Row(
                        spacing: 20,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter.deny(RegExp('^0+')),
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (_) => controller.checkFields(),
                                label: context.l10n.season,
                                hintText: context.l10n.yearHint,
                                controller: controller.yearController,
                              ),
                            ),
                          ),
                          Expanded(
                            child: BlackButton(
                              isDisabled: !controller.fieldsInputted,
                              onTap: controller.loadAllData,
                              text: context.l10n.search,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (constructors != null && drivers != null)
                    SliverToBoxAdapter(
                      child: TournamentTablesSection(
                        driversStandings: drivers[0].driverStandings!,
                        constructorsStandings: constructors[0].constructorStandings!,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
