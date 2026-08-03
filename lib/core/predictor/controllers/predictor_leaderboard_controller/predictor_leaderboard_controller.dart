import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_entry.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_profile.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'predictor_leaderboard_controller.g.dart';

/// MobX-контроллер экрана лидерборда предиктора.
class PredictorLeaderboardController = PredictorLeaderboardControllerBase
    with _$PredictorLeaderboardController;

abstract class PredictorLeaderboardControllerBase with Store {
  PredictorLeaderboardControllerBase({
    required PredictorLeaderboardRepository repository,
    required this.year,
    required int myPoints,
  }) : _repository = repository,
       _myPoints = myPoints;

  final PredictorLeaderboardRepository _repository;

  final String year;
  final int _myPoints;

  @observable
  PredictorLeaderboardProfile profile = const PredictorLeaderboardProfile();

  @observable
  AsyncValue<List<PredictorLeaderboardEntry>> entries = const AsyncValue.loading();

  @observable
  String nicknameDraft = '';

  @observable
  bool optInAgreed = false;

  @observable
  bool isSaving = false;

  @observable
  String? formErrorKey;

  @observable
  bool allDataIsLoaded = false;

  int get myPoints => _myPoints;

  @computed
  CustomException? get screenError => entries.exception;

  @computed
  List<PredictorLeaderboardEntry> get rankedEntries => entries.value ?? const [];

  @computed
  PredictorLeaderboardEntry? get myEntry {
    final uid = _repository.currentUid;
    if (uid == null || !profile.leaderboardOptIn) {
      return null;
    }
    for (final e in rankedEntries) {
      if (e.uid == uid) {
        return e;
      }
    }
    return null;
  }

  @computed
  bool get showJoinForm => !profile.canShowOnLeaderboard;

  @action
  Future<void> load() async {
    allDataIsLoaded = false;
    formErrorKey = null;
    entries = const AsyncValue.loading();
    try {
      final loadedProfile = await _repository.loadProfile();
      profile = loadedProfile;
      nicknameDraft = loadedProfile.nickname ?? '';
      optInAgreed = loadedProfile.leaderboardOptIn;
      final list = await _repository.loadLeaderboard(year);
      entries = entries.toValue(list);
    } on Object catch (e, st) {
      entries = entries.toErrorFrom(
        CustomException(
          title: ErrorCopy.unexpectedError,
          subtitle: ErrorCopy.errorRetrySubtitle,
          parentException: e is Exception ? e : null,
          stackTrace: st,
        ),
      );
    }
    allDataIsLoaded = screenError == null;
  }

  @action
  void setNicknameDraft(String value) {
    nicknameDraft = value;
    formErrorKey = null;
  }

  @action
  void setOptInAgreed(bool value) {
    optInAgreed = value;
    formErrorKey = null;
  }

  @action
  Future<bool> join() async {
    if (isSaving) {
      return false;
    }
    if (!optInAgreed) {
      formErrorKey = 'predictorLeaderboardOptInRequired';
      return false;
    }
    isSaving = true;
    formErrorKey = null;
    try {
      final result = await _repository.join(
        nickname: nicknameDraft,
        year: year,
        totalPoints: _myPoints,
      );
      if (!result.isSuccess) {
        formErrorKey = result.errorKey;
        return false;
      }
      await load();
      return true;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> saveNickname() async {
    if (isSaving) {
      return false;
    }
    isSaving = true;
    formErrorKey = null;
    try {
      final result = await _repository.updateNickname(
        nickname: nicknameDraft,
        year: year,
      );
      if (!result.isSuccess) {
        formErrorKey = result.errorKey;
        return false;
      }
      await load();
      return true;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> leave() async {
    if (isSaving) {
      return false;
    }
    isSaving = true;
    formErrorKey = null;
    try {
      final result = await _repository.leave(year: year);
      if (!result.isSuccess) {
        formErrorKey = result.errorKey;
        return false;
      }
      await load();
      return true;
    } finally {
      isSaving = false;
    }
  }
}
