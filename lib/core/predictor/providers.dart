import 'package:f1_pet_project/core/predictor/managers/predictor_leaderboard_page_manager.dart';
import 'package:f1_pet_project/core/predictor/managers/predictor_page_manager.dart';
import 'package:f1_pet_project/core/predictor/managers/predictor_weekend_detail_page_manager.dart';
import 'package:f1_pet_project/core/predictor/state/state_holders/predictor_leaderboard_page_state_holder.dart';
import 'package:f1_pet_project/core/predictor/state/state_holders/predictor_page_state_holder.dart';
import 'package:f1_pet_project/core/predictor/state/state_holders/predictor_weekend_detail_page_state_holder.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_leaderboard_page_args.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_leaderboard_page_view_model.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_page_view_model.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_args.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана предиктора.
final predictorPageStateHolderProvider =
    NotifierProvider.autoDispose<PredictorPageStateHolder, PredictorPageViewModel>(
      PredictorPageStateHolder.new,
    );

/// Manager экрана предиктора.
final predictorPageManagerProvider = Provider.autoDispose<PredictorPageManager>((ref) {
  final manager = PredictorPageManager(
    holder: ref.watch(predictorPageStateHolderProvider.notifier),
    predictorRepository: ref.watch(predictorRepositoryProvider),
    leaderboardRepository: ref.watch(predictorLeaderboardRepositoryProvider),
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
    standingsRepository: ref.watch(currentStandingsRepositoryProvider),
    driverCatalogRepository: ref.watch(driverCatalogRepositoryProvider),
    raceWeekendRepository: ref.watch(raceWeekendRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});

/// State holder экрана лидерборда (family по [PredictorLeaderboardPageArgs]).
final predictorLeaderboardPageStateHolderProvider = NotifierProvider.autoDispose
    .family<PredictorLeaderboardPageStateHolder, PredictorLeaderboardPageViewModel, PredictorLeaderboardPageArgs>(
      PredictorLeaderboardPageStateHolder.new,
    );

/// Manager экрана лидерборда.
final predictorLeaderboardPageManagerProvider =
    Provider.autoDispose.family<PredictorLeaderboardPageManager, PredictorLeaderboardPageArgs>((ref, args) {
      final manager = PredictorLeaderboardPageManager(
        args: args,
        holder: ref.watch(predictorLeaderboardPageStateHolderProvider(args).notifier),
        repository: ref.watch(predictorLeaderboardRepositoryProvider),
      );
      ref.onDispose(manager.dispose);
      return manager;
    });

/// State holder экрана сравнения уикенда (family по [PredictorWeekendDetailPageArgs]).
final predictorWeekendDetailPageStateHolderProvider = NotifierProvider.autoDispose.family<
  PredictorWeekendDetailPageStateHolder,
  PredictorWeekendDetailPageViewModel,
  PredictorWeekendDetailPageArgs
>(PredictorWeekendDetailPageStateHolder.new);

/// Manager экрана сравнения уикенда.
final predictorWeekendDetailPageManagerProvider =
    Provider.autoDispose.family<PredictorWeekendDetailPageManager, PredictorWeekendDetailPageArgs>((ref, args) {
      final manager = PredictorWeekendDetailPageManager(
        args: args,
        holder: ref.watch(predictorWeekendDetailPageStateHolderProvider(args).notifier),
        raceWeekendRepository: ref.watch(raceWeekendRepositoryProvider),
        driverCatalogRepository: ref.watch(driverCatalogRepositoryProvider),
      );
      ref.onDispose(manager.dispose);
      return manager;
    });
