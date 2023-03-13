import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/race_info_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/qualification_table/qualification_table.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/qualification_table/table_parts/qualification_table_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/race_info_table/race_info_table_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// TODO(pavlov): что осталось добавить
// 1) информация о пит стопах
// 2) информация о лучших кругах и поуле
// ??

class RaceInfoScreen extends ElementaryWidget<IRaceInfoScreenWM> {
  final RacesModel raceModel;
  RaceInfoScreen({
    required this.raceModel,
    super.key,
  }) : super((context) =>
            createRaceInfoScreenWM(context: context, racesModel: raceModel));

  @override
  Widget build(IRaceInfoScreenWM wm) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Подробная информация',
        onPop: wm.onPop,
      ),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _Body(wm: wm)
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.red,
                      ),
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final IRaceInfoScreenWM wm;
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
                  wm.raceModel.raceName,
                  style: AppStyles.h2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: StaticData.defaultVerticallPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Сезон: ${wm.raceModel.season}',
                        style: AppStyles.h2,
                      ),
                      Text(
                        'Раунд: ${wm.raceModel.round}',
                        style: AppStyles.h2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        StateNotifierBuilder<bool>(
          listenableState: wm.raceAppBarPinned,
          builder: (_, raceAppBarPinned) {
            return SliverAppBar(
              backgroundColor: AppTheme.red,
              pinned: raceAppBarPinned!,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: const RaceInfoTableAppBar(),
            );
          },
        ),
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('race_info_table'),
            onVisibilityChanged: wm.onRaceTableVisibilityChanged,
            child: RaceInfoTable(
              raceModel: wm.raceModel,
              withPrimaryRow: false,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: StaticData.defaultVerticallPadding),
        ),
        StateNotifierBuilder<bool>(
          listenableState: wm.qualificationAppBarPinned,
          builder: (_, qualificationAppBarPinned) {
            return SliverAppBar(
              backgroundColor: AppTheme.red,
              pinned: qualificationAppBarPinned!,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: const QualificationTableAppBar(),
            );
          },
        ),
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('qualification_info_table'),
            onVisibilityChanged: wm.onQualificationTableVisibilityChanged,
            child: QualificationTable(
              qualifyingResults: wm.qualifyingResults.value!.data!,
            ),
          ),
        ),
        // TODO(check): что делать, когда у нас есть спринт?
      ],
    );
  }
}
