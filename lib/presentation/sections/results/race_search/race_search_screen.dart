import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/info_message_section.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/search_button_section.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/search_fields_section.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/search_result_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RaceSearchScreen extends ElementaryWidget<IRaceSearchScreenWM> {
  const RaceSearchScreen({
    super.key,
  }) : super(createRaceSearchScreenWM);

  @override
  Widget build(IRaceSearchScreenWM wm) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Поиск гонки',
        onPop: wm.onPop,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: wm.scrollController,
          shrinkWrap: true,
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            const SliverToBoxAdapter(child: InfoMessageSection()),
            SliverToBoxAdapter(child: SearchFieldsSection(wm: wm)),
            SliverToBoxAdapter(
              child: StateNotifierBuilder<bool>(
                listenableState: wm.dataIsLoaded,
                builder: (_, dataIsLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchButtonSection(wm: wm),
                      SearchResultSection(wm: wm),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
