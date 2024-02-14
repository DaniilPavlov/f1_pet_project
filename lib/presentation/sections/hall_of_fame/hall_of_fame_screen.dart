import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/champions_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';

@RoutePage()
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
            if (wm.screenError.value == null) {
              return dataIsLoaded!
                  ? _Body(wm: wm)
                  : const CustomLoadingIndicator();
            }
            return ErrorBody(
              onTap: wm.loadAllData,
              title: wm.screenError.value!.title,
              subtitle: wm.screenError.value!.subtitle,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.wm});
  final IHallOfFameScreenWM wm;

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
              if (wm.constructorsChampions.value.data != null &&
                  wm.driversChampions.value.data != null)
                ChampionsSection(
                  constructorsChampions: wm.constructorsChampions.value.data!,
                  driversChampions: wm.driversChampions.value.data!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
