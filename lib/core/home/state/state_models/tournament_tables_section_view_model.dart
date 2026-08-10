import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_tables_section_view_model.freezed.dart';

/// UI-состояние переключателя таблиц пилоты/конструкторы.
@freezed
abstract class TournamentTablesSectionViewModel with _$TournamentTablesSectionViewModel {
  const factory TournamentTablesSectionViewModel({
    /// Активная вкладка (0 — пилоты, 1 — конструкторы).
    @Default(0) int activeTable,
  }) = _TournamentTablesSectionViewModel;
}
