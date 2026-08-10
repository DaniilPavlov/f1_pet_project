import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season_summary.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_order.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predictor_page_view_model.freezed.dart';

/// UI-состояние экрана предиктора.
@freezed
abstract class PredictorPageViewModel with _$PredictorPageViewModel {
  const PredictorPageViewModel._();

  const factory PredictorPageViewModel({
    /// Текущее время для блокировки.
    required DateTime now,
    /// Раунды сезона.
    @Default(Loadable.loading()) Loadable<List<RacesModel>> races,
    /// Ростер пилотов.
    @Default(Loadable.loading()) Loadable<List<DriverModel>> drivers,
    /// Команды по ID пилота.
    @Default(<String, ConstructorModel>{}) Map<String, ConstructorModel> constructorsByDriverId,
    /// Порядок чемпионата.
    @Default(<String>[]) List<String> championshipDriverOrder,
    /// Локальное хранилище предиктов.
    @Default(PredictorStore(seasons: {})) PredictorStore store,
    /// Store с сервера (может отличаться по пункты).
    @Default(Loadable.loading()) Loadable<PredictorStore> predictions,
    /// Данные полностью загружены.
    @Default(false) bool allDataIsLoaded,
    /// Активная вкладка (квалификация / гонка).
    @Default(PredictorGridKind.qualifying) PredictorGridKind selectedGrid,
    /// Черновик предикта квалификации.
    @Default(<String>[]) List<String> draftQualifyingOrder,
    /// Черновик предикта гонки.
    @Default(<String>[]) List<String> draftRaceOrder,
  }) = _PredictorPageViewModel;

  CustomException? get screenError => firstException([races, drivers, predictions]);

  String? get seasonYear {
    final list = races.value;
    if (list == null || list.isEmpty) {
      return null;
    }
    return list.first.season;
  }

  int get seasonTotalPoints {
    final year = seasonYear;
    if (year == null) {
      return 0;
    }
    return store.season(year)?.totalPoints ?? 0;
  }

  /// Ближайшая ещё не стартовавшая гонка.
  RacesModel? get upcomingRace {
    final list = races.value;
    if (list == null) {
      return null;
    }
    final upcoming = list.where((race) => RaceDateTimeHelper.isUpcoming(race, now)).toList()
      ..sort((a, b) => RaceDateTimeHelper.raceLocal(a).compareTo(RaceDateTimeHelper.raceLocal(b)));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  DateTime? get lockAt {
    final race = upcomingRace;
    if (race == null) {
      return null;
    }
    return PredictorLock.lockAt(race);
  }

  bool get isLocked {
    final race = upcomingRace;
    if (race == null) {
      return true;
    }
    return PredictorLock.isLocked(race, now);
  }

  bool get missingQualifyingTime {
    final race = upcomingRace;
    return race != null && race.qualifying == null;
  }

  CountdownParts get lockCountdown {
    final at = lockAt;
    if (at == null) {
      return CountdownParts.zero;
    }
    return CountdownParts.until(at, now);
  }

  PredictorWeekendPrediction? get currentPrediction {
    final race = upcomingRace;
    final year = seasonYear;
    if (race == null || year == null) {
      return null;
    }
    return store.weekend(year: year, round: race.round);
  }

  /// История сезона без текущего upcoming (если он ещё не завершён).
  List<PredictorWeekendPrediction> get historyWeekends {
    final year = seasonYear;
    if (year == null) {
      return const [];
    }
    final season = store.season(year);
    if (season == null) {
      return const [];
    }
    final upcomingRound = upcomingRace?.round;
    return season.weekendsSorted.where((w) => w.round != upcomingRound).toList().reversed.toList();
  }

  /// Прошлые сезоны с предиктами (для кнопок под историей).
  List<PredictorSeasonSummary> get archivedSeasonSummaries {
    final current = seasonYear;
    final list = store.seasons.values
        .where((season) => season.year != current && season.weekends.isNotEmpty)
        .map(PredictorSeasonSummary.fromSeason)
        .toList()
      ..sort((a, b) => b.year.compareTo(a.year));
    return list;
  }

  Map<String, DriverModel> get driversById {
    final list = drivers.value ?? const <DriverModel>[];
    return {for (final d in list) d.driverId: d};
  }
}
