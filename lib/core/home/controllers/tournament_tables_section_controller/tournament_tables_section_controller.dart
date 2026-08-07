import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние переключателя таблиц пилоты/конструкторы.
@immutable
class TournamentTablesSectionState {
  const TournamentTablesSectionState({this.activeTable = 0});

  final int activeTable;

  TournamentTablesSectionState copyWith({int? activeTable}) {
    return TournamentTablesSectionState(activeTable: activeTable ?? this.activeTable);
  }
}

/// Переключает активную таблицу между пилотами и конструкторами.
class TournamentTablesSectionController extends Notifier<TournamentTablesSectionState> {
  @override
  TournamentTablesSectionState build() => const TournamentTablesSectionState();

  /// Устанавливает индекс отображаемой таблицы.
  void changeActiveTable(int value) {
    state = state.copyWith(activeTable: value);
  }
}

final tournamentTablesSectionControllerProvider =
    NotifierProvider.autoDispose<TournamentTablesSectionController, TournamentTablesSectionState>(
      TournamentTablesSectionController.new,
    );
