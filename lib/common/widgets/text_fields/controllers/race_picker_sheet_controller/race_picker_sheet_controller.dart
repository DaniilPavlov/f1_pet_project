import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние bottom sheet выбора гонки.
@immutable
class RacePickerSheetState {
  const RacePickerSheetState({this.races = const Loadable.loading()});

  final Loadable<List<RacesModel>> races;

  RacePickerSheetState copyWith({Loadable<List<RacesModel>>? races}) {
    return RacePickerSheetState(races: races ?? this.races);
  }
}

/// Загружает этапы выбранного сезона.
class RacePickerSheetController extends Notifier<RacePickerSheetState> {
  RacePickerSheetController(this.seasonYear);

  final String seasonYear;

  @override
  RacePickerSheetState build() => const RacePickerSheetState();

  /// Подтягивает гонки сезона.
  Future<void> load() async {
    state = state.copyWith(races: state.races.toLoading());
    try {
      final list = await ref.read(raceWeekendRepositoryProvider).seasonRaces(year: seasonYear);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(races: state.races.toValue(list));
    } on Object catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(races: state.races.toError(error.toString()));
    }
  }
}

final racePickerSheetControllerProvider = NotifierProvider.autoDispose
    .family<RacePickerSheetController, RacePickerSheetState, String>(RacePickerSheetController.new);
