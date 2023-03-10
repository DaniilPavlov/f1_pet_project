import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/race_info_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_table_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// TODO(pavlov): нужно продумать как показать подробную информацию
class RaceInfoScreen extends ElementaryWidget<IRaceInfoScreenWM> {
  final RacesModel raceModel;
  const RaceInfoScreen({
    required this.raceModel,
    super.key,
  }) : super(createRaceInfoScreenWM);

  @override
  Widget build(IRaceInfoScreenWM wm) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Подробная информация',
        onPop: wm.onPop,
      ),
      body: SafeArea(
        child: CustomScrollView(
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: StaticData.defaultVerticallPadding,
                  left: StaticData.defaultHorizontalPadding,
                  right: StaticData.defaultHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      raceModel.raceName,
                      style: AppStyles.h2,
                    ),
                    const SizedBox(
                      height: StaticData.defaultVerticallPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Сезон: ${raceModel.season}',
                          style: AppStyles.h2,
                        ),
                        Text(
                          'Раунд: ${raceModel.round}',
                          style: AppStyles.h2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            StateNotifierBuilder<bool>(
              listenableState: wm.appBarPinned,
              builder: (_, appBarPinned) {
                return SliverAppBar(
                  backgroundColor: AppTheme.red,
                  pinned: appBarPinned!,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: const RaceInfoTableAppBar(),
                );
              },
            ),
            SliverToBoxAdapter(
              child: VisibilityDetector(
                key: const Key('race_info_table'),
                onVisibilityChanged: wm.onTableVisibilityChanged,
                child: RaceInfoTable(
                  raceModel: raceModel,
                  withPrimaryRow: false,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: StaticData.defaultVerticallPadding),
            ),
          ],
        ),
      ),
    );
  }
}
