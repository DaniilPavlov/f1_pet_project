import 'package:f1_pet_project/core/results/h2h/managers/h2h_page_manager.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/state/state_holders/h2h_page_state_holder.dart';
import 'package:f1_pet_project/core/results/h2h/state/state_models/h2h_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана H2H (family по [H2hMode]).
final h2hPageStateHolderProvider =
    NotifierProvider.autoDispose.family<H2hPageStateHolder, H2hPageViewModel, H2hMode>(
      H2hPageStateHolder.new,
    );

/// Manager экрана H2H.
final h2hPageManagerProvider = Provider.autoDispose.family<H2hPageManager, H2hMode>((ref, mode) {
  final manager = H2hPageManager(
    holder: ref.watch(h2hPageStateHolderProvider(mode).notifier),
    seasonsRepository: ref.watch(seasonsRepositoryProvider),
    h2hRepository: ref.watch(h2hRepositoryProvider),
    driverCatalogRepository: ref.watch(driverCatalogRepositoryProvider),
    constructorCatalogRepository: ref.watch(constructorCatalogRepositoryProvider),
    currentStandingsRepository: ref.watch(currentStandingsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
    analytics: ref.watch(analyticsGatewayProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
