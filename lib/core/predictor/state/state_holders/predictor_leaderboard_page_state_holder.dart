import 'package:f1_pet_project/core/predictor/state/state_models/predictor_leaderboard_page_args.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_leaderboard_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [PredictorLeaderboardPageViewModel] для экрана лидерборда.
class PredictorLeaderboardPageStateHolder extends Notifier<PredictorLeaderboardPageViewModel> {
  PredictorLeaderboardPageStateHolder(this.args);

  /// Аргументы с годом и пунктами пользователя.
  final PredictorLeaderboardPageArgs args;

  @override
  PredictorLeaderboardPageViewModel build() => const PredictorLeaderboardPageViewModel();

  PredictorLeaderboardPageViewModel get viewModel => state;

  void setViewModel(PredictorLeaderboardPageViewModel value) => state = value;
}
