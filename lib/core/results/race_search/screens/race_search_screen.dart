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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран поиска результатов гонки по сезону и раунду.
@RoutePage()
class RaceSearchScreen extends ConsumerWidget {
  const RaceSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localeControllerProvider).locale.languageCode;
    final controller = ref.read(raceSearchScreenControllerProvider(languageCode).notifier);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.raceSearchTitle, onPop: () => context.router.maybePop()),
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          shrinkWrap: true,
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            const SliverToBoxAdapter(child: InfoMessageSection()),
            SliverToBoxAdapter(child: SearchFieldsSection(languageCode: languageCode)),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchButtonSection(languageCode: languageCode),
                  SearchResultSection(languageCode: languageCode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
