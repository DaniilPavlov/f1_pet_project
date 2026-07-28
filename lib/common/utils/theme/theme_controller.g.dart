// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeController on ThemeControllerBase, Store {
  Computed<ThemeMode>? _$themeModeComputed;

  @override
  ThemeMode get themeMode => (_$themeModeComputed ??= Computed<ThemeMode>(
    () => super.themeMode,
    name: 'ThemeControllerBase.themeMode',
  )).value;
  Computed<IconData>? _$preferenceIconComputed;

  @override
  IconData get preferenceIcon =>
      (_$preferenceIconComputed ??= Computed<IconData>(
        () => super.preferenceIcon,
        name: 'ThemeControllerBase.preferenceIcon',
      )).value;

  late final _$preferenceAtom = Atom(
    name: 'ThemeControllerBase.preference',
    context: context,
  );

  @override
  AppThemePreference get preference {
    _$preferenceAtom.reportRead();
    return super.preference;
  }

  @override
  set preference(AppThemePreference value) {
    _$preferenceAtom.reportWrite(value, super.preference, () {
      super.preference = value;
    });
  }

  late final _$isLoadedAtom = Atom(
    name: 'ThemeControllerBase.isLoaded',
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
    'ThemeControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$cycleAsyncAction = AsyncAction(
    'ThemeControllerBase.cycle',
    context: context,
  );

  @override
  Future<void> cycle() {
    return _$cycleAsyncAction.run(() => super.cycle());
  }

  late final _$setPreferenceAsyncAction = AsyncAction(
    'ThemeControllerBase.setPreference',
    context: context,
  );

  @override
  Future<void> setPreference(AppThemePreference value) {
    return _$setPreferenceAsyncAction.run(() => super.setPreference(value));
  }

  @override
  String toString() {
    return '''
preference: ${preference},
isLoaded: ${isLoaded},
themeMode: ${themeMode},
preferenceIcon: ${preferenceIcon}
    ''';
  }
}
