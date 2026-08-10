import 'package:f1_pet_project/core/home/managers/home_page_manager.dart';
import 'package:f1_pet_project/core/home/managers/tournament_tables_section_manager.dart';
import 'package:f1_pet_project/core/home/state/state_holders/home_page_state_holder.dart';
import 'package:f1_pet_project/core/home/state/state_holders/tournament_tables_section_state_holder.dart';
import 'package:f1_pet_project/core/home/state/state_models/home_page_view_model.dart';
import 'package:f1_pet_project/core/home/state/state_models/tournament_tables_section_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder главного экрана.
final homePageStateHolderProvider =
    NotifierProvider.autoDispose<HomePageStateHolder, HomePageViewModel>(HomePageStateHolder.new);

/// Manager главного экрана.
final homePageManagerProvider = Provider.autoDispose<HomePageManager>((ref) {
  return HomePageManager(
    holder: ref.watch(homePageStateHolderProvider.notifier),
    currentStandingsRepository: ref.watch(currentStandingsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
});

/// State holder секции турнирных таблиц.
final tournamentTablesSectionStateHolderProvider =
    NotifierProvider.autoDispose<TournamentTablesSectionStateHolder, TournamentTablesSectionViewModel>(
      TournamentTablesSectionStateHolder.new,
    );

/// Manager секции турнирных таблиц.
///
/// [dependencies] нужны, чтобы при override holder во вложенном [ProviderScope]
/// manager тоже монтировался в том же scope (иначе пишет в root holder).
final tournamentTablesSectionManagerProvider = Provider.autoDispose<TournamentTablesSectionManager>(
  (ref) {
    return TournamentTablesSectionManager(
      holder: ref.watch(tournamentTablesSectionStateHolderProvider.notifier),
    );
  },
  dependencies: [tournamentTablesSectionStateHolderProvider],
);
