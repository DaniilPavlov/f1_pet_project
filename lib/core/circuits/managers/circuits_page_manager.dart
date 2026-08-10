import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/circuits/state/state_holders/circuits_page_state_holder.dart';
import 'package:f1_pet_project/core/circuits/state/state_models/circuits_page_view_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/executor.dart';
import 'package:flutter/material.dart';

/// Загрузка списка трасс и переключение вкладок карта/список.
class CircuitsPageManager {
  CircuitsPageManager({
    required CircuitsPageStateHolder holder,
    CircuitsRepository? circuitsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<CircuitsModel> Function()? fetchCircuitsForTest,
  }) : _holder = holder,
       _circuitsRepository = circuitsRepository,
       _dataRefresh = dataRefresh,
       _fetchCircuitsForTest = fetchCircuitsForTest;

  final CircuitsPageStateHolder _holder;
  final CircuitsRepository? _circuitsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<CircuitsModel> Function()? _fetchCircuitsForTest;

  /// Управляет переключением вкладок между картой и списком.
  final pageController = PageController();

  /// Загружает список трасс с сервера.
  Future<void> loadCircuits() async {
    final activePage = _holder.viewModel.activePage;
    _holder.setViewModel(CircuitsPageViewModel.loading(activePage: activePage));

    await execute<CircuitsModel>(
      _fetchCircuits,
      maxAttempts: 3,
      onSuccess: (data) async {
        final circuits = data?.circuitTable.circuits ?? <CircuitModel>[];
        final showingCachedData = await shouldShowOfflineCachedBanner(hasCachedContent: true);
        _holder.setViewModel(
          CircuitsPageViewModel.success(
            circuits: circuits,
            activePage: activePage,
            showingCachedData: showingCachedData,
          ),
        );
      },
      onError: (error) {
        _holder.setViewModel(
          CircuitsPageViewModel.error(exception: error, activePage: activePage),
        );
      },
    );
  }

  /// После появления сети — спрятать баннер без перезагрузки.
  Future<void> dismissOfflineBannerIfOnline() async {
    final current = _holder.viewModel;
    if (current is! CircuitsPageSuccess) {
      return;
    }
    final next = await clearOfflineBannerIfOnline(currentlyShowing: current.showingCachedData);
    _holder.setViewModel(current.copyWith(showingCachedData: next));
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadCircuits();
  }

  /// Переключает активную вкладку (карта или список).
  void changeActivePage(int value) {
    _holder.setViewModel(_holder.viewModel.copyWith(activePage: value));
    if (pageController.hasClients) {
      pageController.animateToPage(value, curve: Curves.ease, duration: const Duration(milliseconds: 250));
    }
  }

  /// Освобождает [pageController].
  void dispose() {
    pageController.dispose();
  }

  Future<CircuitsModel> _fetchCircuits() {
    final forTest = _fetchCircuitsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _circuitsRepository!.all();
  }
}
