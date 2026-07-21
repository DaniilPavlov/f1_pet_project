// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_picker_sheet_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RacePickerSheetController on RacePickerSheetControllerBase, Store {
  late final _$racesAtom = Atom(
    name: 'RacePickerSheetControllerBase.races',
    context: context,
  );

  @override
  AsyncValue<List<RacesModel>> get races {
    _$racesAtom.reportRead();
    return super.races;
  }

  @override
  set races(AsyncValue<List<RacesModel>> value) {
    _$racesAtom.reportWrite(value, super.races, () {
      super.races = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'RacePickerSheetControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
races: ${races}
    ''';
  }
}
