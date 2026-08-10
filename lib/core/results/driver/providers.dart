import 'package:f1_pet_project/core/results/driver/managers/driver_page_manager.dart';
import 'package:f1_pet_project/core/results/driver/state/state_holders/driver_page_state_holder.dart';
import 'package:f1_pet_project/core/results/driver/state/state_models/driver_page_args.dart';
import 'package:f1_pet_project/core/results/driver/state/state_models/driver_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана пилота (family по [DriverPageArgs]).
final driverPageStateHolderProvider =
    NotifierProvider.autoDispose.family<DriverPageStateHolder, DriverPageViewModel, DriverPageArgs>(
      DriverPageStateHolder.new,
    );

/// Manager экрана пилота.
final driverPageManagerProvider = Provider.autoDispose.family<DriverPageManager, DriverPageArgs>((ref, args) {
  final manager = DriverPageManager(
    args: args,
    holder: ref.watch(driverPageStateHolderProvider(args).notifier),
    careerRepository: ref.watch(driverCareerRepositoryProvider),
    espnMediaRepository: ref.watch(espnMediaRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
