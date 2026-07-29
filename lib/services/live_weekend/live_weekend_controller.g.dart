// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_weekend_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LiveWeekendController on LiveWeekendControllerBase, Store {
  Computed<bool>? _$isLiveComputed;

  @override
  bool get isLive => (_$isLiveComputed ??= Computed<bool>(
    () => super.isLive,
    name: 'LiveWeekendControllerBase.isLive',
  )).value;
  Computed<String?>? _$liveSessionAbbreviationComputed;

  @override
  String? get liveSessionAbbreviation =>
      (_$liveSessionAbbreviationComputed ??= Computed<String?>(
        () => super.liveSessionAbbreviation,
        name: 'LiveWeekendControllerBase.liveSessionAbbreviation',
      )).value;

  late final _$scoreboardAtom = Atom(
    name: 'LiveWeekendControllerBase.scoreboard',
    context: context,
  );

  @override
  AsyncValue<EspnScoreboardEvent?> get scoreboard {
    _$scoreboardAtom.reportRead();
    return super.scoreboard;
  }

  @override
  set scoreboard(AsyncValue<EspnScoreboardEvent?> value) {
    _$scoreboardAtom.reportWrite(value, super.scoreboard, () {
      super.scoreboard = value;
    });
  }

  late final _$loadScoreboardAsyncAction = AsyncAction(
    'LiveWeekendControllerBase.loadScoreboard',
    context: context,
  );

  @override
  Future<void> loadScoreboard({bool forceRefresh = false}) {
    return _$loadScoreboardAsyncAction.run(
      () => super.loadScoreboard(forceRefresh: forceRefresh),
    );
  }

  @override
  String toString() {
    return '''
scoreboard: ${scoreboard},
isLive: ${isLive},
liveSessionAbbreviation: ${liveSessionAbbreviation}
    ''';
  }
}
