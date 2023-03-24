import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/champions_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:flutter/material.dart';

class HallOfFameScreen extends ElementaryWidget<IHallOfFameScreenWM> {
  const HallOfFameScreen({
    super.key,
  }) : super(createHallOfFameScreenWM);

  @override
  Widget build(IHallOfFameScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _Body(wm: wm)
                  : const CustomLoadingIndicator();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final IHallOfFameScreenWM wm;
  const _Body({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (wm.constructorsChampions.value != null &&
                  wm.driversChampions.value != null)
                ChampionsSection(
                  constructorsChampions: wm.constructorsChampions.value!.data!,
                  driversChampions: wm.driversChampions.value!.data!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
