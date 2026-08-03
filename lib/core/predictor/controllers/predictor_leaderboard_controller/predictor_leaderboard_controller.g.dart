// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predictor_leaderboard_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PredictorLeaderboardController
    on PredictorLeaderboardControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'PredictorLeaderboardControllerBase.screenError',
      )).value;
  Computed<List<PredictorLeaderboardEntry>>? _$rankedEntriesComputed;

  @override
  List<PredictorLeaderboardEntry> get rankedEntries =>
      (_$rankedEntriesComputed ??= Computed<List<PredictorLeaderboardEntry>>(
        () => super.rankedEntries,
        name: 'PredictorLeaderboardControllerBase.rankedEntries',
      )).value;
  Computed<PredictorLeaderboardEntry?>? _$myEntryComputed;

  @override
  PredictorLeaderboardEntry? get myEntry =>
      (_$myEntryComputed ??= Computed<PredictorLeaderboardEntry?>(
        () => super.myEntry,
        name: 'PredictorLeaderboardControllerBase.myEntry',
      )).value;
  Computed<bool>? _$showJoinFormComputed;

  @override
  bool get showJoinForm => (_$showJoinFormComputed ??= Computed<bool>(
    () => super.showJoinForm,
    name: 'PredictorLeaderboardControllerBase.showJoinForm',
  )).value;

  late final _$profileAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.profile',
    context: context,
  );

  @override
  PredictorLeaderboardProfile get profile {
    _$profileAtom.reportRead();
    return super.profile;
  }

  @override
  set profile(PredictorLeaderboardProfile value) {
    _$profileAtom.reportWrite(value, super.profile, () {
      super.profile = value;
    });
  }

  late final _$entriesAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.entries',
    context: context,
  );

  @override
  AsyncValue<List<PredictorLeaderboardEntry>> get entries {
    _$entriesAtom.reportRead();
    return super.entries;
  }

  @override
  set entries(AsyncValue<List<PredictorLeaderboardEntry>> value) {
    _$entriesAtom.reportWrite(value, super.entries, () {
      super.entries = value;
    });
  }

  late final _$nicknameDraftAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.nicknameDraft',
    context: context,
  );

  @override
  String get nicknameDraft {
    _$nicknameDraftAtom.reportRead();
    return super.nicknameDraft;
  }

  @override
  set nicknameDraft(String value) {
    _$nicknameDraftAtom.reportWrite(value, super.nicknameDraft, () {
      super.nicknameDraft = value;
    });
  }

  late final _$optInAgreedAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.optInAgreed',
    context: context,
  );

  @override
  bool get optInAgreed {
    _$optInAgreedAtom.reportRead();
    return super.optInAgreed;
  }

  @override
  set optInAgreed(bool value) {
    _$optInAgreedAtom.reportWrite(value, super.optInAgreed, () {
      super.optInAgreed = value;
    });
  }

  late final _$isSavingAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.isSaving',
    context: context,
  );

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$formErrorKeyAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.formErrorKey',
    context: context,
  );

  @override
  String? get formErrorKey {
    _$formErrorKeyAtom.reportRead();
    return super.formErrorKey;
  }

  @override
  set formErrorKey(String? value) {
    _$formErrorKeyAtom.reportWrite(value, super.formErrorKey, () {
      super.formErrorKey = value;
    });
  }

  late final _$allDataIsLoadedAtom = Atom(
    name: 'PredictorLeaderboardControllerBase.allDataIsLoaded',
    context: context,
  );

  @override
  bool get allDataIsLoaded {
    _$allDataIsLoadedAtom.reportRead();
    return super.allDataIsLoaded;
  }

  @override
  set allDataIsLoaded(bool value) {
    _$allDataIsLoadedAtom.reportWrite(value, super.allDataIsLoaded, () {
      super.allDataIsLoaded = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'PredictorLeaderboardControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$joinAsyncAction = AsyncAction(
    'PredictorLeaderboardControllerBase.join',
    context: context,
  );

  @override
  Future<bool> join() {
    return _$joinAsyncAction.run(() => super.join());
  }

  late final _$saveNicknameAsyncAction = AsyncAction(
    'PredictorLeaderboardControllerBase.saveNickname',
    context: context,
  );

  @override
  Future<bool> saveNickname() {
    return _$saveNicknameAsyncAction.run(() => super.saveNickname());
  }

  late final _$leaveAsyncAction = AsyncAction(
    'PredictorLeaderboardControllerBase.leave',
    context: context,
  );

  @override
  Future<bool> leave() {
    return _$leaveAsyncAction.run(() => super.leave());
  }

  late final _$PredictorLeaderboardControllerBaseActionController =
      ActionController(
        name: 'PredictorLeaderboardControllerBase',
        context: context,
      );

  @override
  void setNicknameDraft(String value) {
    final _$actionInfo = _$PredictorLeaderboardControllerBaseActionController
        .startAction(
          name: 'PredictorLeaderboardControllerBase.setNicknameDraft',
        );
    try {
      return super.setNicknameDraft(value);
    } finally {
      _$PredictorLeaderboardControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setOptInAgreed(bool value) {
    final _$actionInfo = _$PredictorLeaderboardControllerBaseActionController
        .startAction(name: 'PredictorLeaderboardControllerBase.setOptInAgreed');
    try {
      return super.setOptInAgreed(value);
    } finally {
      _$PredictorLeaderboardControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
profile: ${profile},
entries: ${entries},
nicknameDraft: ${nicknameDraft},
optInAgreed: ${optInAgreed},
isSaving: ${isSaving},
formErrorKey: ${formErrorKey},
allDataIsLoaded: ${allDataIsLoaded},
screenError: ${screenError},
rankedEntries: ${rankedEntries},
myEntry: ${myEntry},
showJoinForm: ${showJoinForm}
    ''';
  }
}
