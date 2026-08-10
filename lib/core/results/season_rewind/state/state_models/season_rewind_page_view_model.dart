import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_rewind_page_view_model.freezed.dart';

/// UI-состояние экрана «Перемотка сезона».
@freezed
abstract class SeasonRewindPageViewModel with _$SeasonRewindPageViewModel {
  const SeasonRewindPageViewModel._();

  const factory SeasonRewindPageViewModel({
    /// Раунды сезона.
    @Default(Loadable.loading()) Loadable<List<RacesModel>> races,
    /// Зачёт пилотов для выбранного раунда.
    @Default(Loadable.loading()) Loadable<List<StandingsListsModel>> driversStandings,
    /// Зачёт конструкторов для выбранного раунда.
    @Default(Loadable.loading()) Loadable<List<StandingsListsModel>> constructorsStandings,
    /// Индекс выбранного раунда в списке.
    @Default(0) int selectedRoundIndex,
    /// Идёт автопрокрутка раундов.
    @Default(false) bool isPlaying,
    /// Данные для графика пилотов.
    @Default([]) List<DriverStandingsModel> chartDrivers,
    /// Данные для графика конструкторов.
    @Default([]) List<ConstructorStandingsModel> chartConstructors,
    /// Раунд, для которого загружены chart данные.
    String? chartRound,
    /// График загружается.
    @Default(false) bool chartLoading,
  }) = _SeasonRewindPageViewModel;

  CustomException? get screenError => firstException([races, driversStandings, constructorsStandings]);

  RacesModel? get selectedRace {
    final list = races.value;
    if (list == null || list.isEmpty) {
      return null;
    }
    if (selectedRoundIndex < 0 || selectedRoundIndex >= list.length) {
      return null;
    }
    return list[selectedRoundIndex];
  }

  bool get canPlay {
    final list = races.value;
    return list != null && list.length > 1;
  }

  bool get hasChartData => chartDrivers.isNotEmpty && chartConstructors.isNotEmpty;

  /// Очки на экране не от [selectedRace] — не показываем chart, пока не догрузим.
  bool get isChartStale {
    final race = selectedRace;
    if (race == null || chartRound == null) {
      return true;
    }
    return chartRound != race.round;
  }
}
