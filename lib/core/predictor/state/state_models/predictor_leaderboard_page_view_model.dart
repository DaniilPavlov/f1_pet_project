import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_entry.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_profile.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predictor_leaderboard_page_view_model.freezed.dart';

/// UI-состояние экрана лидерборда предиктора.
@freezed
abstract class PredictorLeaderboardPageViewModel with _$PredictorLeaderboardPageViewModel {
  const PredictorLeaderboardPageViewModel._();

  const factory PredictorLeaderboardPageViewModel({
    /// Мой профиль на лидерборде.
    @Default(PredictorLeaderboardProfile()) PredictorLeaderboardProfile profile,
    /// Записи лидерборда.
    @Default(Loadable.loading()) Loadable<List<PredictorLeaderboardEntry>> entries,
    /// Черновик никнейма.
    @Default('') String nicknameDraft,
    /// Согласие на opt-in.
    @Default(false) bool optInAgreed,
    /// Идёт сохранение.
    @Default(false) bool isSaving,
    /// Ключ ошибки формы (локализация).
    String? formErrorKey,
    /// Данные полностью загружены.
    @Default(false) bool allDataIsLoaded,
  }) = _PredictorLeaderboardPageViewModel;

  CustomException? get screenError => entries.exception;

  List<PredictorLeaderboardEntry> get rankedEntries => entries.value ?? const [];

  bool get showJoinForm => !profile.canShowOnLeaderboard;
}
