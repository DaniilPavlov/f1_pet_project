import 'dart:async';

import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_career_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Аргументы семейства провайдера экрана пилота.
@immutable
class DriverScreenArgs {
  const DriverScreenArgs({
    required this.driver,
    this.currentConstructors = const [],
  });

  final DriverModel driver;
  final List<ConstructorModel> currentConstructors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverScreenArgs &&
          runtimeType == other.runtimeType &&
          driver.driverId == other.driver.driverId;

  @override
  int get hashCode => driver.driverId.hashCode;
}

/// Состояние экрана пилота.
@immutable
class DriverState {
  const DriverState({
    this.careerStats = const Loadable.loading(),
    this.espnCard = const Loadable.loading(),
  });

  final Loadable<CareerStats<ConstructorModel>> careerStats;
  final Loadable<EspnDriverCardData> espnCard;

  CustomException? get screenError => firstException([careerStats]);

  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  EspnDriverCardData get espnCardData => espnCard.value ?? const EspnDriverCardData();

  bool get isEspnLoading => espnCard.isLoading;

  DriverState copyWith({
    Loadable<CareerStats<ConstructorModel>>? careerStats,
    Loadable<EspnDriverCardData>? espnCard,
  }) {
    return DriverState(
      careerStats: careerStats ?? this.careerStats,
      espnCard: espnCard ?? this.espnCard,
    );
  }
}

/// Загружает карьеру (Jolpica) и ESPN-медиа пилота.
class DriverScreenController extends Notifier<DriverState> {
  DriverScreenController(
    this.args, {
    @visibleForTesting
    Future<CareerStats<ConstructorModel>> Function({
      required String driverId,
      List<ConstructorModel> current,
    })?
    fetchCareerStatsForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
  }) : _fetchCareerStatsForTest = fetchCareerStatsForTest,
       _dataRefreshForTest = dataRefreshForTest;

  final DriverScreenArgs args;
  final Future<CareerStats<ConstructorModel>> Function({
    required String driverId,
    List<ConstructorModel> current,
  })?
  _fetchCareerStatsForTest;
  final AppDataRefresh? _dataRefreshForTest;

  DriverModel get driver => args.driver;

  List<ConstructorModel> get currentConstructors => args.currentConstructors;

  EspnMediaRepository get _espnMediaRepository => ref.read(espnMediaRepositoryProvider);

  DriverCareerRepository get _careerRepository => ref.read(driverCareerRepositoryProvider);

  @override
  DriverState build() => const DriverState();

  /// Загружает карьеру и ESPN-данные параллельно.
  Future<void> loadAll() async {
    await Future.wait([loadCareerStats(), loadEspnCard()]);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  Future<void> refreshAll() async {
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (_fetchCareerStatsForTest == null) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadAll();
  }

  /// Totals сразу, списки гонок — фоном (progressive).
  Future<void> loadCareerStats() async {
    final forTest = _fetchCareerStatsForTest;
    if (forTest != null) {
      await runAsyncLoad(
        fetch: () => forTest(driverId: driver.driverId, current: currentConstructors),
        getField: () => state.careerStats,
        setField: (value) => state = state.copyWith(careerStats: value),
        onSuccess: (data) {
          if (data != null) {
            state = state.copyWith(careerStats: state.careerStats.toValue(data));
          }
        },
      );
      return;
    }

    await runAsyncLoad(
      fetch: () => _careerRepository.loadTotals(
        driverId: driver.driverId,
        current: currentConstructors,
      ),
      getField: () => state.careerStats,
      setField: (value) => state = state.copyWith(careerStats: value),
      onSuccess: (data) {
        if (data != null) {
          state = state.copyWith(careerStats: state.careerStats.toValue(data));
          unawaited(_completeRaceLists(data));
        }
      },
    );
  }

  Future<void> _completeRaceLists(CareerStats<ConstructorModel> totals) async {
    try {
      final complete = await _careerRepository.loadRaceLists(
        driverId: driver.driverId,
        totals: totals,
      );
      if (!ref.mounted) {
        return;
      }
      final current = state.careerStats.value;
      if (current == null || current.races != totals.races || current.wins != totals.wins) {
        return;
      }
      state = state.copyWith(careerStats: state.careerStats.toValue(complete));
    } on Object {
      // Totals уже на экране — списки просто останутся неполными.
    }
  }

  /// Загружает фото / флаг / новости ESPN (ошибка → пустые данные, экран не ломаем).
  Future<void> loadEspnCard() async {
    if (_fetchCareerStatsForTest != null) {
      state = state.copyWith(espnCard: const Loadable.value(value: EspnDriverCardData()));
      return;
    }
    state = state.copyWith(espnCard: state.espnCard.toLoading());
    try {
      final data = await _espnMediaRepository.driverCardData(
        givenName: driver.givenName,
        familyName: driver.familyName,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(espnCard: state.espnCard.toValue(data));
    } on Object {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(espnCard: state.espnCard.toValue(const EspnDriverCardData()));
    }
  }
}

final driverScreenControllerProvider =
    NotifierProvider.autoDispose.family<DriverScreenController, DriverState, DriverScreenArgs>(
      DriverScreenController.new,
    );
