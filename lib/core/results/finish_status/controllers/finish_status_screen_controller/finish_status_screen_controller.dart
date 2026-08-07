import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/results/finish_status/repositories/finish_status_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана статусов финиша.
@immutable
class FinishStatusState {
  const FinishStatusState({this.statuses = const Loadable.loading()});

  final Loadable<List<FinishStatusItem>> statuses;

  CustomException? get screenError => statuses.exception;

  bool get isLoaded => statuses.isValue && statuses.value != null;

  FinishStatusState copyWith({Loadable<List<FinishStatusItem>>? statuses}) {
    return FinishStatusState(statuses: statuses ?? this.statuses);
  }
}

/// Загружает статусы финиша за выбранный сезон.
class FinishStatusScreenController extends Notifier<FinishStatusState> {
  FinishStatusScreenController({
    @visibleForTesting SeasonsRepository? seasonsRepositoryForTest,
    @visibleForTesting Future<List<FinishStatusItem>> Function(String year)? fetchStatusesForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
  }) : _seasonsRepositoryForTest = seasonsRepositoryForTest,
       _fetchStatusesForTest = fetchStatusesForTest,
       _dataRefreshForTest = dataRefreshForTest;

  final SeasonsRepository? _seasonsRepositoryForTest;
  final Future<List<FinishStatusItem>> Function(String year)? _fetchStatusesForTest;
  final AppDataRefresh? _dataRefreshForTest;

  late final TextEditingController yearController;

  FinishStatusRepository get _finishStatusRepository => ref.read(finishStatusRepositoryProvider);

  @override
  FinishStatusState build() {
    yearController = TextEditingController(text: '2026');
    ref.onDispose(yearController.dispose);
    return const FinishStatusState();
  }

  Future<void> bootstrap() async {
    final repository = _seasonsRepositoryForTest ??
        (_fetchStatusesForTest == null ? ref.read(seasonsRepositoryProvider) : null);
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

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  Future<void> refreshAll() async {
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (_fetchStatusesForTest == null) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadAllData();
  }

  Future<void> loadAllData() async {
    if (!yearController.isValidYear) {
      return;
    }
    final year = yearController.text;
    await runAsyncLoad<List<FinishStatusItem>, List<FinishStatusItem>>(
      fetch: () => _fetchStatuses(year: year),
      getField: () => state.statuses,
      setField: (value) => state = state.copyWith(statuses: value),
      onSuccess: (data) {
        if (data != null) {
          state = state.copyWith(statuses: state.statuses.toValue(data));
        }
      },
    );
  }

  Future<List<FinishStatusItem>> _fetchStatuses({required String year}) {
    final forTest = _fetchStatusesForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _finishStatusRepository.forSeason(year: year);
  }
}

final finishStatusScreenControllerProvider =
    NotifierProvider.autoDispose<FinishStatusScreenController, FinishStatusState>(
      FinishStatusScreenController.new,
    );
