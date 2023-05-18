import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/pit_stops_table/pit_stops_table.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/pit_stops_table/table_parts/pit_stops_table_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/qualification_table/qualification_table.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/qualification_table/table_parts/qualification_table_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/race_info_table/race_info_table_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/providers/results/race_info/race_info_data.dart';
import 'package:f1_pet_project/providers/results/race_info/race_info_providers.dart';
import 'package:f1_pet_project/providers/results/race_info/race_model_parameter.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

// TODO(think): горизонтальная таблица не вставляется в кастом скрол вью
// возможно для каждой таблицы нужно сделать отдельный экран

// TODO(pavlov): что осталось добавить
// 1) по нажатию на гонщика в первой таблице открывать полную его информацию по гонке
// ??

@RoutePage()
class RaceInfoScreen extends StatelessWidget {
  final RacesModel raceModel;
  const RaceInfoScreen({
    required this.raceModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Подробная информация',
        onPop: context.router.removeLast,
      ),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final raceInfoData = ref.watch(raceInfoDataProvider(
              RaceModelParameter(
                yearRound: [raceModel.season, raceModel.round],
              ),
            ));
            return raceInfoData.when(
              loading: () => const CustomLoadingIndicator(),
              error: (err, stack) => ErrorBody(
                onTap: () => ref.refresh(raceInfoDataProvider(
                  RaceModelParameter(
                    yearRound: [raceModel.season, raceModel.round],
                  ),
                )),
                title: err.toString(),
                subtitle: '',
              ),
              data: (data) {
                if (data.pitStops == null || data.qualifyingResults == null) {
                  return ErrorBody(
                    onTap: () => ref.refresh(raceInfoDataProvider(
                      RaceModelParameter(
                        yearRound: [raceModel.season, raceModel.round],
                      ),
                    )),
                    title: 'Произошла ошибка',
                    subtitle: '',
                  );
                } else {
                  return _Body(
                    raceInfoData: data,
                    raceModel: raceModel,
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  final RaceInfoData raceInfoData;
  final RacesModel raceModel;
  const _Body({required this.raceInfoData, required this.raceModel, Key? key})
      : super(key: key);

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  @override
  Widget build(BuildContext context) {
    final fastestLap = ref.read(raceInfoFastestLapProvider(widget.raceModel));
    final raceAppBarPinned = ref.watch(raceAppBarPinnedProvider);
    final qualificationAppBarPinned =
        ref.watch(qualificationAppBarPinnedProvider);
    final pitStopsAppBarPinned = ref.watch(pitStopsAppBarPinnedProvider);
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
                  widget.raceModel.raceName,
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
                        'Сезон: ${widget.raceModel.season}',
                        style: AppStyles.h2,
                      ),
                      Text(
                        'Раунд: ${widget.raceModel.round}',
                        style: AppStyles.h2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverAppBar(
          backgroundColor: AppTheme.red,
          pinned: raceAppBarPinned,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: const RaceInfoTableAppBar(),
        ),
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('race_info_table'),
            onVisibilityChanged: (info) =>
                onRaceTableVisibilityChanged(info: info, ref: ref),
            child: RaceInfoTable(
              fastestLap: fastestLap,
              raceModel: widget.raceModel,
              withPrimaryRow: false,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: StaticData.defaultVerticallPadding),
        ),
        SliverAppBar(
          backgroundColor: AppTheme.red,
          pinned: qualificationAppBarPinned,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: const QualificationTableAppBar(),
        ),
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('qualification_info_table'),
            onVisibilityChanged: (info) =>
                onQualificationTableVisibilityChanged(info: info, ref: ref),
            child: QualificationTable(
              qualifyingResults: widget.raceInfoData.qualifyingResults!,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: StaticData.defaultVerticallPadding),
        ),
        SliverAppBar(
          backgroundColor: AppTheme.red,
          pinned: pitStopsAppBarPinned,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: const PitStopsTableAppBar(),
        ),
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('pit_stops_info_table'),
            onVisibilityChanged: (info) =>
                onPitStopsTableVisibilityChanged(info: info, ref: ref),
            child: PitStopsTable(
              pitStops: widget.raceInfoData.pitStops!,
            ),
          ),
        ),
      ],
    );
  }

  void onRaceTableVisibilityChanged({
    required VisibilityInfo info,
    required WidgetRef ref,
  }) {
    ref.read(raceAppBarPinnedProvider.notifier).update((state) =>
        info.visibleBounds.top < info.size.height - 150 &&
        info.visibleBounds.right != 0);
  }

  void onQualificationTableVisibilityChanged({
    required VisibilityInfo info,
    required WidgetRef ref,
  }) {
    ref.read(qualificationAppBarPinnedProvider.notifier).update((state) =>
        info.visibleBounds.top < info.size.height - 150 &&
        info.visibleBounds.right != 0);
  }

  void onPitStopsTableVisibilityChanged({
    required VisibilityInfo info,
    required WidgetRef ref,
  }) {
    ref.read(pitStopsAppBarPinnedProvider.notifier).update((state) =>
        info.visibleBounds.top < info.size.height - 150 &&
        info.visibleBounds.right != 0);
  }
}
