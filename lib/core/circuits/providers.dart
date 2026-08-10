import 'package:f1_pet_project/core/circuits/managers/circuit_page_manager.dart';
import 'package:f1_pet_project/core/circuits/managers/circuits_page_manager.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/state/state_holders/circuit_page_state_holder.dart';
import 'package:f1_pet_project/core/circuits/state/state_holders/circuits_page_state_holder.dart';
import 'package:f1_pet_project/core/circuits/state/state_models/circuit_page_view_model.dart';
import 'package:f1_pet_project/core/circuits/state/state_models/circuits_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана списка трасс.
final circuitsPageStateHolderProvider =
    NotifierProvider.autoDispose<CircuitsPageStateHolder, CircuitsPageViewModel>(CircuitsPageStateHolder.new);

/// Manager экрана списка трасс.
final circuitsPageManagerProvider = Provider.autoDispose<CircuitsPageManager>((ref) {
  final manager = CircuitsPageManager(
    holder: ref.watch(circuitsPageStateHolderProvider.notifier),
    circuitsRepository: ref.watch(circuitsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});

/// State holder экрана детали трассы (family по [CircuitModel]).
final circuitPageStateHolderProvider =
    NotifierProvider.autoDispose.family<CircuitPageStateHolder, CircuitPageViewModel, CircuitModel>(
      CircuitPageStateHolder.new,
    );

/// Manager экрана детали трассы.
final circuitPageManagerProvider = Provider.autoDispose.family<CircuitPageManager, CircuitModel>((ref, circuit) {
  return CircuitPageManager(
    circuit: circuit,
    holder: ref.watch(circuitPageStateHolderProvider(circuit).notifier),
    circuitsRepository: ref.watch(circuitsRepositoryProvider),
    wikipediaRepository: ref.watch(wikipediaPageImageRepositoryProvider),
    statsRepository: ref.watch(circuitStatsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
});
