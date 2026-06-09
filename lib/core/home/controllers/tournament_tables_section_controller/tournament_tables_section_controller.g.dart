// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_tables_section_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TournamentTablesSectionController
    on TournamentTablesSectionControllerBase, Store {
  late final _$activeTableAtom = Atom(
    name: 'TournamentTablesSectionControllerBase.activeTable',
    context: context,
  );

  @override
  int get activeTable {
    _$activeTableAtom.reportRead();
    return super.activeTable;
  }

  @override
  set activeTable(int value) {
    _$activeTableAtom.reportWrite(value, super.activeTable, () {
      super.activeTable = value;
    });
  }

  late final _$TournamentTablesSectionControllerBaseActionController =
      ActionController(
        name: 'TournamentTablesSectionControllerBase',
        context: context,
      );

  @override
  void changeActiveTable(int value) {
    final _$actionInfo = _$TournamentTablesSectionControllerBaseActionController
        .startAction(
          name: 'TournamentTablesSectionControllerBase.changeActiveTable',
        );
    try {
      return super.changeActiveTable(value);
    } finally {
      _$TournamentTablesSectionControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
activeTable: ${activeTable}
    ''';
  }
}
