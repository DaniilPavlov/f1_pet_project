import 'package:f1_pet_project/core/results/race_info/state/state_models/race_info_page_view_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [RaceInfoPageViewModel] для детального экрана гонки.
class RaceInfoPageStateHolder extends Notifier<RaceInfoPageViewModel> {
  RaceInfoPageStateHolder(this.raceModel);

  /// Модель гонки с расписанием сессий.
  final RacesModel raceModel;

  @override
  RaceInfoPageViewModel build() => const RaceInfoPageViewModel();

  RaceInfoPageViewModel get viewModel => state;

  void setViewModel(RaceInfoPageViewModel value) => state = value;
}
