import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_entry.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:f1_pet_project/core/predictor/state/state_holders/predictor_leaderboard_page_state_holder.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_leaderboard_page_args.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/foundation.dart';

/// Загрузка лидерборда и opt-in / nickname.
class PredictorLeaderboardPageManager {
  PredictorLeaderboardPageManager({
    required this.args,
    required PredictorLeaderboardPageStateHolder holder,
    PredictorLeaderboardRepository? repository,
    @visibleForTesting PredictorLeaderboardRepository? repositoryForTest,
  }) : _holder = holder,
       _repository = repositoryForTest ?? repository;

  /// Аргументы экрана: год и мои пункты.
  final PredictorLeaderboardPageArgs args;
  final PredictorLeaderboardPageStateHolder _holder;
  final PredictorLeaderboardRepository? _repository;

  var _disposed = false;

  /// Год лидерборда.
  String get year => args.year;
  /// Мои очки в сезоне.
  int get myPoints => args.myPoints;

  /// Моя запись в лидерборде (если я opt-in).
  PredictorLeaderboardEntry? get myEntry {
    final uid = _repository?.currentUid;
    if (uid == null || !_holder.viewModel.profile.leaderboardOptIn) {
      return null;
    }
    for (final e in _holder.viewModel.rankedEntries) {
      if (e.uid == uid) {
        return e;
      }
    }
    return null;
  }

  /// Загружает профиль пользователя и лидерборд года.
  Future<void> load() async {
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        allDataIsLoaded: false,
        formErrorKey: null,
        entries: const Loadable.loading(),
      ),
    );
    try {
      final repository = _repository!;
      final loadedProfile = await repository.loadProfile();
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          profile: loadedProfile,
          nicknameDraft: loadedProfile.nickname ?? '',
          optInAgreed: loadedProfile.leaderboardOptIn,
        ),
      );
      final list = await repository.loadLeaderboard(year);
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(entries: _holder.viewModel.entries.toValue(list)),
      );
    } on Object catch (e, st) {
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          entries: _holder.viewModel.entries.toErrorFrom(
            CustomException(
              title: ErrorCopy.unexpectedError,
              subtitle: ErrorCopy.errorRetrySubtitle,
              parentException: e is Exception ? e : null,
              stackTrace: st,
            ),
          ),
        ),
      );
    }
    if (_disposed) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(allDataIsLoaded: _holder.viewModel.screenError == null),
    );
  }

  /// Обновляет черновик никнейма.
  void setNicknameDraft(String value) {
    _holder.setViewModel(_holder.viewModel.copyWith(nicknameDraft: value, formErrorKey: null));
  }

  /// Обновляет статус согласия на opt-in.
  void setOptInAgreed(bool value) {
    _holder.setViewModel(_holder.viewModel.copyWith(optInAgreed: value, formErrorKey: null));
  }

  /// Присоединяется к лидерборду с введённым никнеймом.
  Future<bool> join() async {
    if (_holder.viewModel.isSaving) {
      return false;
    }
    if (!_holder.viewModel.optInAgreed) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(formErrorKey: 'predictorLeaderboardOptInRequired'),
      );
      return false;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(isSaving: true, formErrorKey: null));
    try {
      final result = await _repository!.join(
        nickname: _holder.viewModel.nicknameDraft,
        year: year,
        totalPoints: myPoints,
      );
      if (!result.isSuccess) {
        if (_disposed) {
          return false;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(formErrorKey: result.errorKey, isSaving: false),
        );
        return false;
      }
      await load();
      return true;
    } finally {
      if (!_disposed) {
        _holder.setViewModel(_holder.viewModel.copyWith(isSaving: false));
      }
    }
  }

  /// Обновляет никнейм на лидерборде.
  Future<bool> saveNickname() async {
    if (_holder.viewModel.isSaving) {
      return false;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(isSaving: true, formErrorKey: null));
    try {
      final result = await _repository!.updateNickname(
        nickname: _holder.viewModel.nicknameDraft,
        year: year,
      );
      if (!result.isSuccess) {
        if (_disposed) {
          return false;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(formErrorKey: result.errorKey, isSaving: false),
        );
        return false;
      }
      await load();
      return true;
    } finally {
      if (!_disposed) {
        _holder.setViewModel(_holder.viewModel.copyWith(isSaving: false));
      }
    }
  }

  /// Удаляется с лидерборда.
  Future<bool> leave() async {
    if (_holder.viewModel.isSaving) {
      return false;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(isSaving: true, formErrorKey: null));
    try {
      final result = await _repository!.leave(year: year);
      if (!result.isSuccess) {
        if (_disposed) {
          return false;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(formErrorKey: result.errorKey, isSaving: false),
        );
        return false;
      }
      await load();
      return true;
    } finally {
      if (!_disposed) {
        _holder.setViewModel(_holder.viewModel.copyWith(isSaving: false));
      }
    }
  }

  /// Очищает ресурсы менеджера.
  void dispose() => _disposed = true;
}
