import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/core/results/race_search/components/info_message_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_button_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_fields_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_result_section.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран поиска результатов гонки по сезону и раунду.
@RoutePage()
class RaceSearchScreen extends StatelessWidget {
  const RaceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();

    return Observer(
      builder: (context) {
        final localeCode = localeController.locale.languageCode;

        return Provider<RaceSearchScreenController>(
          key: ValueKey('race_search_$localeCode'),
          create: (context) => RaceSearchScreenController(
            l10n: context.l10n,
            raceWeekendRepository: context.read<RaceWeekendRepository>(),
          ),
          dispose: (_, controller) => controller.dispose(),
          child: Builder(
            builder: (context) {
              final controller = context.read<RaceSearchScreenController>();
              return Scaffold(
                appBar: CustomAppBar(title: context.l10n.raceSearchTitle, onPop: () => context.router.removeLast()),
                body: SafeArea(
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    scrollBehavior: AntiGlowBehavior(),
                    slivers: const [
                      SliverToBoxAdapter(child: InfoMessageSection()),
                      SliverToBoxAdapter(child: SearchFieldsSection()),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [SearchButtonSection(), SearchResultSection()],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
