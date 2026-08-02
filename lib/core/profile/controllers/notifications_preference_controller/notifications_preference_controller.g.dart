// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_preference_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationsPreferenceController
    on NotificationsPreferenceControllerBase, Store {
  Computed<bool>? _$remoteAllowsComputed;

  @override
  bool get remoteAllows => (_$remoteAllowsComputed ??= Computed<bool>(
    () => super.remoteAllows,
    name: 'NotificationsPreferenceControllerBase.remoteAllows',
  )).value;
  Computed<bool>? _$effectivelyEnabledComputed;

  @override
  bool get effectivelyEnabled =>
      (_$effectivelyEnabledComputed ??= Computed<bool>(
        () => super.effectivelyEnabled,
        name: 'NotificationsPreferenceControllerBase.effectivelyEnabled',
      )).value;
  Computed<bool>? _$canToggleComputed;

  @override
  bool get canToggle => (_$canToggleComputed ??= Computed<bool>(
    () => super.canToggle,
    name: 'NotificationsPreferenceControllerBase.canToggle',
  )).value;

  late final _$userEnabledAtom = Atom(
    name: 'NotificationsPreferenceControllerBase.userEnabled',
    context: context,
  );

  @override
  bool get userEnabled {
    _$userEnabledAtom.reportRead();
    return super.userEnabled;
  }

  @override
  set userEnabled(bool value) {
    _$userEnabledAtom.reportWrite(value, super.userEnabled, () {
      super.userEnabled = value;
    });
  }

  late final _$isLoadedAtom = Atom(
    name: 'NotificationsPreferenceControllerBase.isLoaded',
    context: context,
  );

  @override
  bool get isLoaded {
    _$isLoadedAtom.reportRead();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.reportWrite(value, super.isLoaded, () {
      super.isLoaded = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'NotificationsPreferenceControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$setEnabledAsyncAction = AsyncAction(
    'NotificationsPreferenceControllerBase.setEnabled',
    context: context,
  );

  @override
  Future<void> setEnabled({required bool enabled, required Locale locale}) {
    return _$setEnabledAsyncAction.run(
      () => super.setEnabled(enabled: enabled, locale: locale),
    );
  }

  @override
  String toString() {
    return '''
userEnabled: ${userEnabled},
isLoaded: ${isLoaded},
remoteAllows: ${remoteAllows},
effectivelyEnabled: ${effectivelyEnabled},
canToggle: ${canToggle}
    ''';
  }
}
