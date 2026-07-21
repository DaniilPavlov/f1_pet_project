// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_picker_sheet_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SeasonPickerSheetController on SeasonPickerSheetControllerBase, Store {
  late final _$yearsAtom = Atom(
    name: 'SeasonPickerSheetControllerBase.years',
    context: context,
  );

  @override
  AsyncValue<List<String>> get years {
    _$yearsAtom.reportRead();
    return super.years;
  }

  @override
  set years(AsyncValue<List<String>> value) {
    _$yearsAtom.reportWrite(value, super.years, () {
      super.years = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'SeasonPickerSheetControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
years: ${years}
    ''';
  }
}
