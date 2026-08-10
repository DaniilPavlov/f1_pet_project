import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/results/finish_status/repositories/finish_status_repository.dart';
import 'package:f1_pet_project/core/results/finish_status/state/state_holders/finish_status_page_state_holder.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';

/// Загружает статусы финиша за выбранный сезон.
class FinishStatusPageManager {
  FinishStatusPageManager({
    required FinishStatusPageStateHolder holder,
    FinishStatusRepository? finishStatusRepository,
    SeasonsRepository? seasonsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<List<FinishStatusItem>> Function(String year)? fetchStatusesForTest,
  }) : _holder = holder,
       _finishStatusRepository = finishStatusRepository,
       _seasonsRepository = seasonsRepository,
       _dataRefresh = dataRefresh,
       _fetchStatusesForTest = fetchStatusesForTest;

  final FinishStatusPageStateHolder _holder;
  final FinishStatusRepository? _finishStatusRepository;
  final SeasonsRepository? _seasonsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<List<FinishStatusItem>> Function(String year)? _fetchStatusesForTest;

  /// Ввод года для фильтра.
  final yearController = TextEditingController(text: '2026');

  var _disposed = false;

  /// Подставляет актуальный сезон из API и грузит статусы.
  Future<void> bootstrap() async {
    final repository = _seasonsRepository;
    if (repository != null) {
      try {
        final years = await repository.getSeasonYears();
        if (years.isNotEmpty) {
          yearController.text = years.first;
        }
      } on Object {
        // fallback-год уже в менеджере
      }
    }
    if (_disposed) {
      return;
    }
    await loadAllData();
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadAllData();
  }

  /// Загружает статусы финиша за выбранный год.
  Future<void> loadAllData() async {
    if (!yearController.isValidYear) {
      return;
    }
    final year = yearController.text;
    await runAsyncLoad<List<FinishStatusItem>, List<FinishStatusItem>>(
      fetch: () => _fetchStatuses(year: year),
      getField: () => _holder.viewModel.statuses,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(statuses: value));
      },
      onSuccess: (data) {
        if (_disposed || data == null) {
          return;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(statuses: _holder.viewModel.statuses.toValue(data)),
        );
      },
    );
  }

  /// Очищает ресурсы менеджера.
  void dispose() {
    _disposed = true;
    yearController.dispose();
  }

  Future<List<FinishStatusItem>> _fetchStatuses({required String year}) {
    final forTest = _fetchStatusesForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _finishStatusRepository!.forSeason(year: year);
  }
}
