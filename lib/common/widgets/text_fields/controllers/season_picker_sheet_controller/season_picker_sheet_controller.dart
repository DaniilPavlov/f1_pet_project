import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние bottom sheet выбора сезона.
@immutable
class SeasonPickerSheetState {
  const SeasonPickerSheetState({this.years = const Loadable.loading()});

  final Loadable<List<String>> years;

  SeasonPickerSheetState copyWith({Loadable<List<String>>? years}) {
    return SeasonPickerSheetState(years: years ?? this.years);
  }
}

/// Загружает список годов сезонов.
class SeasonPickerSheetController extends Notifier<SeasonPickerSheetState> {
  @override
  SeasonPickerSheetState build() => const SeasonPickerSheetState();

  /// Подтягивает годы (новые сверху).
  Future<void> load() async {
    state = state.copyWith(years: state.years.toLoading());
    try {
      final data = await ref.read(seasonsRepositoryProvider).getSeasonYears();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(years: state.years.toValue(data));
    } on Object catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(years: state.years.toError(error.toString()));
    }
  }
}

final seasonPickerSheetControllerProvider =
    NotifierProvider.autoDispose<SeasonPickerSheetController, SeasonPickerSheetState>(
      SeasonPickerSheetController.new,
    );
