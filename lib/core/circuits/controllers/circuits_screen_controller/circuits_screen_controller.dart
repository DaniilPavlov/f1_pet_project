import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана трасс.
@immutable
class CircuitsScreenState {
  const CircuitsScreenState({
    this.circuits = const Loadable.loading(),
    this.activePage = 0,
    this.showingCachedData = false,
  });

  final Loadable<List<CircuitModel>> circuits;
  final int activePage;

  /// Офлайн + список трасс из кэша.
  final bool showingCachedData;

  CustomException? get screenError => circuits.exception;

  CircuitsScreenState copyWith({
    Loadable<List<CircuitModel>>? circuits,
    int? activePage,
    bool? showingCachedData,
  }) {
    return CircuitsScreenState(
      circuits: circuits ?? this.circuits,
      activePage: activePage ?? this.activePage,
      showingCachedData: showingCachedData ?? this.showingCachedData,
    );
  }
}

/// Управляет загрузкой трасс и переключением вкладок списка/карты.
class CircuitsScreenController extends Notifier<CircuitsScreenState> {
  CircuitsScreenController({
    @visibleForTesting Future<CircuitsModel> Function()? fetchCircuitsForTest,
  }) : _fetchCircuitsForTest = fetchCircuitsForTest;

  final Future<CircuitsModel> Function()? _fetchCircuitsForTest;

  final pageController = PageController();

  CircuitsRepository? get _circuitsRepository {
    if (_fetchCircuitsForTest != null) {
      return null;
    }
    return ref.read(circuitsRepositoryProvider);
  }

  AppDataRefresh? get _dataRefresh {
    if (_fetchCircuitsForTest != null) {
      return null;
    }
    return ref.read(appDataRefreshProvider);
  }

  @override
  CircuitsScreenState build() {
    ref.onDispose(pageController.dispose);
    return const CircuitsScreenState();
  }

  /// Загружает список трасс с сервера.
  Future<void> loadCircuits() async {
    await runAsyncLoad<CircuitsModel, List<CircuitModel>>(
      fetch: _fetchCircuits,
      getField: () => state.circuits,
      setField: (value) => state = state.copyWith(circuits: value),
      onSuccess: (data) => state = state.copyWith(circuits: state.circuits.toValue(data!.circuitTable.circuits)),
    );
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      showingCachedData: await shouldShowOfflineCachedBanner(hasCachedContent: state.circuits.isValue),
    );
  }

  /// После появления сети — спрятать баннер без перезагрузки.
  Future<void> dismissOfflineBannerIfOnline() async {
    final next = await clearOfflineBannerIfOnline(currentlyShowing: state.showingCachedData);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(showingCachedData: next);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка списка.
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (!ref.mounted) {
      return;
    }
    await loadCircuits();
  }

  /// Переключает активную вкладку (карта или список).
  void changeActivePage(int value) {
    state = state.copyWith(activePage: value);
    if (pageController.hasClients) {
      pageController.animateToPage(state.activePage, curve: Curves.ease, duration: const Duration(milliseconds: 250));
    }
  }

  Future<CircuitsModel> _fetchCircuits() {
    final forTest = _fetchCircuitsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _circuitsRepository!.all();
  }
}

final circuitsScreenControllerProvider =
    NotifierProvider.autoDispose<CircuitsScreenController, CircuitsScreenState>(CircuitsScreenController.new);
