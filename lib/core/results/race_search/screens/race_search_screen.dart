import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/core/results/race_search/components/info_message_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_button_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_fields_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_result_section.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class RaceSearchScreen extends StatelessWidget {
  const RaceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RaceSearchScreenController>(
      create: (_) => RaceSearchScreenController(),
      dispose: (_, controller) => controller.dispose(),
      child: Builder(
        builder: (context) {
          final controller = context.read<RaceSearchScreenController>();
          return Scaffold(
            appBar: CustomAppBar(title: 'Поиск гонки', onPop: () => context.router.removeLast()),
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
  }
}
