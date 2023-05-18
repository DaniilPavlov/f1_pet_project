import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/info_message_section.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/search_button_consumer_widget.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/search_fields_section.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/sections/search_result_consumer_widget.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/providers/results/race_info/race_year_round_parameter.dart.dart';
import 'package:f1_pet_project/providers/results/race_search/race_search_providers.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RaceSearchScreen extends ConsumerStatefulWidget {
  const RaceSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RaceSearchScreen> createState() => _RaceSearchScreenState();
}

class _RaceSearchScreenState extends ConsumerState<RaceSearchScreen> {
  final yearController = TextEditingController();
  final roundController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    roundController.dispose();
    yearController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final raceResults = ref.watch(raceSearchLoadResultsProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Поиск гонки',
        onPop: context.router.removeLast,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          shrinkWrap: true,
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            const SliverToBoxAdapter(child: InfoMessageSection()),
            SliverToBoxAdapter(
              child: SearchFieldsSection(
                yearController: yearController,
                roundController: roundController,
                checkFields: () =>
                    ref.read(raceSearchFieldsInputtedProvider.notifier).state =
                        yearController.text.length == 4 &&
                            roundController.text.isNotEmpty,
              ),
            ),
            SliverToBoxAdapter(
              child: raceResults.when(
                loading: () => const CustomLoadingIndicator(),
                error: (error, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchResultConsumerWidget(error: error.toString()),
                  ],
                ),
                data: (result) {
                  if (result != null) {
                    // _searchedRace.content(data.RaceTable.Races[0]);
                    Future<void>.delayed(
                      const Duration(milliseconds: 100),
                      animateToTable,
                    );
                  } else {
                    // _searchedRace.content(null);
                    // _errorMessage.accept(
                    //   'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.',
                    // );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchButtonConsumerWidget(
                        onTap: () =>
                            ref.read(raceYearRoundProvider.notifier).update(
                                  (state) => RaceYearRoundParameter(yearRound: [
                                    yearController.text,
                                    roundController.text,
                                  ]),
                                ),
                      ),
                      SearchResultConsumerWidget(result: result),
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

  void animateToTable() {
    Future<void>.delayed(
      const Duration(milliseconds: 100),
      () => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}
