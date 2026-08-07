import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_career_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Аргументы семейства провайдера экрана конструктора.
@immutable
class ConstructorScreenArgs {
  const ConstructorScreenArgs({
    required this.constructor,
    this.currentDrivers = const [],
  });

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConstructorScreenArgs &&
          runtimeType == other.runtimeType &&
          constructor.constructorId == other.constructor.constructorId;

  @override
  int get hashCode => constructor.constructorId.hashCode;
}

/// Состояние экрана конструктора.
@immutable
class ConstructorState {
  const ConstructorState({
    this.careerStats = const Loadable.loading(),
    this.espnNews = const Loadable.loading(),
  });

  final Loadable<CareerStats<DriverModel>> careerStats;
  final Loadable<List<NewsArticleModel>> espnNews;

  CustomException? get screenError => firstException([careerStats]);

  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  List<NewsArticleModel> get news => espnNews.value ?? const [];

  ConstructorState copyWith({
    Loadable<CareerStats<DriverModel>>? careerStats,
    Loadable<List<NewsArticleModel>>? espnNews,
  }) {
    return ConstructorState(
      careerStats: careerStats ?? this.careerStats,
      espnNews: espnNews ?? this.espnNews,
    );
  }
}

/// Загружает карьеру (Jolpica) и новости команды (ESPN).
class ConstructorScreenController extends Notifier<ConstructorState> {
  ConstructorScreenController(
    this.args, {
    @visibleForTesting
    Future<CareerStats<DriverModel>> Function({
      required String constructorId,
      List<DriverModel> current,
    })?
    fetchCareerStatsForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
  }) : _fetchCareerStatsForTest = fetchCareerStatsForTest,
       _dataRefreshForTest = dataRefreshForTest;

  final ConstructorScreenArgs args;
  final Future<CareerStats<DriverModel>> Function({
    required String constructorId,
    List<DriverModel> current,
  })?
  _fetchCareerStatsForTest;
  final AppDataRefresh? _dataRefreshForTest;

  ConstructorModel get constructor => args.constructor;

  List<DriverModel> get currentDrivers => args.currentDrivers;

  EspnMediaRepository get _espnMediaRepository => ref.read(espnMediaRepositoryProvider);

  ConstructorCareerRepository get _careerRepository => ref.read(constructorCareerRepositoryProvider);

  @override
  ConstructorState build() => const ConstructorState();

  /// Загружает карьеру и ESPN-новости параллельно.
  Future<void> loadAll() async {
    await Future.wait([loadCareerStats(), loadEspnNews()]);
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

  /// Загружает (или перезагружает) карьерную статистику.
  Future<void> loadCareerStats() async {
    await runAsyncLoad(
      fetch: () => _fetchCareerStats(constructorId: constructor.constructorId, current: currentDrivers),
      getField: () => state.careerStats,
      setField: (value) => state = state.copyWith(careerStats: value),
      onSuccess: (data) {
        if (data != null) {
          state = state.copyWith(careerStats: state.careerStats.toValue(data));
        }
      },
    );
  }

  /// ESPN-новости команды (ошибка → пустой список, экран не ломаем).
  Future<void> loadEspnNews() async {
    if (_fetchCareerStatsForTest != null) {
      state = state.copyWith(espnNews: const Loadable.value(value: []));
      return;
    }
    state = state.copyWith(espnNews: state.espnNews.toLoading());
    try {
      final data = await _espnMediaRepository.constructorNews(
        constructorId: constructor.constructorId,
        constructorName: constructor.name,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(espnNews: state.espnNews.toValue(data));
    } on Object {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(espnNews: state.espnNews.toValue(const []));
    }
  }

  Future<CareerStats<DriverModel>> _fetchCareerStats({
    required String constructorId,
    required List<DriverModel> current,
  }) {
    final forTest = _fetchCareerStatsForTest;
    if (forTest != null) {
      return forTest(constructorId: constructorId, current: current);
    }
    return _careerRepository.load(constructorId: constructorId, current: current);
  }
}

final constructorScreenControllerProvider =
    NotifierProvider.autoDispose.family<ConstructorScreenController, ConstructorState, ConstructorScreenArgs>(
      ConstructorScreenController.new,
    );
