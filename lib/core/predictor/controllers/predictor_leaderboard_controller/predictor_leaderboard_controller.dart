import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_entry.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_profile.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Аргументы семейства лидерборда.
@immutable
class PredictorLeaderboardArgs {
  const PredictorLeaderboardArgs({required this.year, required this.myPoints});

  final String year;
  final int myPoints;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictorLeaderboardArgs && year == other.year && myPoints == other.myPoints;

  @override
  int get hashCode => Object.hash(year, myPoints);
}

/// Состояние экрана лидерборда предиктора.
@immutable
class PredictorLeaderboardState {
  const PredictorLeaderboardState({
    this.profile = const PredictorLeaderboardProfile(),
    this.entries = const Loadable.loading(),
    this.nicknameDraft = '',
    this.optInAgreed = false,
    this.isSaving = false,
    this.formErrorKey,
    this.allDataIsLoaded = false,
  });

  final PredictorLeaderboardProfile profile;
  final Loadable<List<PredictorLeaderboardEntry>> entries;
  final String nicknameDraft;
  final bool optInAgreed;
  final bool isSaving;
  final String? formErrorKey;
  final bool allDataIsLoaded;

  CustomException? get screenError => entries.exception;

  List<PredictorLeaderboardEntry> get rankedEntries => entries.value ?? const [];

  bool get showJoinForm => !profile.canShowOnLeaderboard;

  PredictorLeaderboardState copyWith({
    PredictorLeaderboardProfile? profile,
    Loadable<List<PredictorLeaderboardEntry>>? entries,
    String? nicknameDraft,
    bool? optInAgreed,
    bool? isSaving,
    String? formErrorKey,
    bool clearFormErrorKey = false,
    bool? allDataIsLoaded,
  }) {
    return PredictorLeaderboardState(
      profile: profile ?? this.profile,
      entries: entries ?? this.entries,
      nicknameDraft: nicknameDraft ?? this.nicknameDraft,
      optInAgreed: optInAgreed ?? this.optInAgreed,
      isSaving: isSaving ?? this.isSaving,
      formErrorKey: clearFormErrorKey ? null : (formErrorKey ?? this.formErrorKey),
      allDataIsLoaded: allDataIsLoaded ?? this.allDataIsLoaded,
    );
  }
}

/// Контроллер экрана лидерборда предиктора.
class PredictorLeaderboardController extends Notifier<PredictorLeaderboardState> {
  PredictorLeaderboardController(
    this.args, {
    @visibleForTesting PredictorLeaderboardRepository? repositoryForTest,
  }) : _repositoryForTest = repositoryForTest;

  final PredictorLeaderboardArgs args;
  final PredictorLeaderboardRepository? _repositoryForTest;

  String get year => args.year;
  int get myPoints => args.myPoints;

  PredictorLeaderboardRepository get _repository =>
      _repositoryForTest ?? ref.read(predictorLeaderboardRepositoryProvider);

  @override
  PredictorLeaderboardState build() => const PredictorLeaderboardState();

  PredictorLeaderboardEntry? get myEntry {
    final uid = _repository.currentUid;
    if (uid == null || !state.profile.leaderboardOptIn) {
      return null;
    }
    for (final e in state.rankedEntries) {
      if (e.uid == uid) {
        return e;
      }
    }
    return null;
  }

  Future<void> load() async {
    state = state.copyWith(
      allDataIsLoaded: false,
      clearFormErrorKey: true,
      entries: const Loadable.loading(),
    );
    try {
      final loadedProfile = await _repository.loadProfile();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        profile: loadedProfile,
        nicknameDraft: loadedProfile.nickname ?? '',
        optInAgreed: loadedProfile.leaderboardOptIn,
      );
      final list = await _repository.loadLeaderboard(year);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(entries: state.entries.toValue(list));
    } on Object catch (e, st) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        entries: state.entries.toErrorFrom(
          CustomException(
            title: ErrorCopy.unexpectedError,
            subtitle: ErrorCopy.errorRetrySubtitle,
            parentException: e is Exception ? e : null,
            stackTrace: st,
          ),
        ),
      );
    }
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(allDataIsLoaded: state.screenError == null);
  }

  void setNicknameDraft(String value) {
    state = state.copyWith(nicknameDraft: value, clearFormErrorKey: true);
  }

  void setOptInAgreed(bool value) {
    state = state.copyWith(optInAgreed: value, clearFormErrorKey: true);
  }

  Future<bool> join() async {
    if (state.isSaving) {
      return false;
    }
    if (!state.optInAgreed) {
      state = state.copyWith(formErrorKey: 'predictorLeaderboardOptInRequired');
      return false;
    }
    state = state.copyWith(isSaving: true, clearFormErrorKey: true);
    try {
      final result = await _repository.join(
        nickname: state.nicknameDraft,
        year: year,
        totalPoints: myPoints,
      );
      if (!result.isSuccess) {
        if (!ref.mounted) {
          return false;
        }
        state = state.copyWith(formErrorKey: result.errorKey, isSaving: false);
        return false;
      }
      await load();
      return true;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  Future<bool> saveNickname() async {
    if (state.isSaving) {
      return false;
    }
    state = state.copyWith(isSaving: true, clearFormErrorKey: true);
    try {
      final result = await _repository.updateNickname(
        nickname: state.nicknameDraft,
        year: year,
      );
      if (!result.isSuccess) {
        if (!ref.mounted) {
          return false;
        }
        state = state.copyWith(formErrorKey: result.errorKey, isSaving: false);
        return false;
      }
      await load();
      return true;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  Future<bool> leave() async {
    if (state.isSaving) {
      return false;
    }
    state = state.copyWith(isSaving: true, clearFormErrorKey: true);
    try {
      final result = await _repository.leave(year: year);
      if (!result.isSuccess) {
        if (!ref.mounted) {
          return false;
        }
        state = state.copyWith(formErrorKey: result.errorKey, isSaving: false);
        return false;
      }
      await load();
      return true;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }
}

final predictorLeaderboardControllerProvider = NotifierProvider.autoDispose
    .family<PredictorLeaderboardController, PredictorLeaderboardState, PredictorLeaderboardArgs>(
      PredictorLeaderboardController.new,
    );
