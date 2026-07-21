import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/finish_status/loaders/season_status_loader.dart';
import 'package:f1_pet_project/core/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'finish_status_screen_controller.g.dart';

/// MobX-контроллер экрана статусов финиша.
class FinishStatusScreenController = FinishStatusScreenControllerBase with _$FinishStatusScreenController;

/// Загружает статусы финиша за выбранный сезон.
abstract class FinishStatusScreenControllerBase with Store {
  FinishStatusScreenControllerBase({
    this.seasonsRepository,
    Future<List<FinishStatusItem>> Function(String year)? fetchStatuses,
  }) : _fetchStatusesOverride = fetchStatuses {
    yearController = TextEditingController(text: '2026');
  }

  final SeasonsRepository? seasonsRepository;
  final Future<List<FinishStatusItem>> Function(String year)? _fetchStatusesOverride;

  late final TextEditingController yearController;

  @observable
  AsyncValue<List<FinishStatusItem>> statuses = const AsyncValue.loading();

  @computed
  CustomException? get screenError => statuses.exception;

  @computed
  bool get isLoaded => statuses.isValue && statuses.value != null;

  void dispose() {
    yearController.dispose();
  }

  @action
  Future<void> bootstrap() async {
    final repository = seasonsRepository;
    if (repository != null) {
      try {
        final years = await repository.getSeasonYears();
        if (years.isNotEmpty) {
          yearController.text = years.first;
        }
      } on Object {
        // fallback-год уже в контроллере
      }
    }
    await loadAllData();
  }

  @action
  Future<void> loadAllData() async {
    if (!yearController.isValidYear) {
      return;
    }
    final year = yearController.text;
    await runAsyncLoad<List<FinishStatusItem>, List<FinishStatusItem>>(
      fetch: () => _fetchStatuses(year: year),
      getField: () => statuses,
      setField: (value) => statuses = value,
      onSuccess: (data) {
        if (data != null) {
          statuses = statuses.toValue(data);
        }
      },
    );
  }

  Future<List<FinishStatusItem>> _fetchStatuses({required String year}) {
    final override = _fetchStatusesOverride;
    if (override != null) {
      return override(year);
    }
    return SeasonStatusLoader.loadData(year: year);
  }
}
