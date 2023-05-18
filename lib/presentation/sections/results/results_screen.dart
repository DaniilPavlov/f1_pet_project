import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/sections/last_race_table/last_race_table_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/providers/results/results_providers.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final lastRaceData = ref.watch(resultsDataProvider);
            return lastRaceData.when(
              loading: () => const CustomLoadingIndicator(),
              error: (err, stack) => ErrorBody(
                onTap: () => ref.refresh(resultsDataProvider),
                title: err.toString(),
                subtitle: '',
              ),
              data: (data) => _Body(lastRace: data),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final RacesModel? lastRace;
  const _Body({required this.lastRace, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: lastRace == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: StaticData.defaultVerticallPadding,
                  ),
                  child: Consumer(
                    builder: (context, ref, child) => LastRaceTableSection(
                      lastRace: lastRace!,
                      fastestLap: ref.read(resultsFastestLapProvider),
                    ),
                  ),
                ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.defaultHorizontalPadding,
              vertical: StaticData.defaultVerticallPadding,
            ),
            child: RedBorderContainer(
              title: 'Выбрать конкретную гонку',
              onTap: () async =>
                  context.router.navigate(const RaceSearchRoute()),
            ),
          ),
        ),
      ],
    );
  }
}
