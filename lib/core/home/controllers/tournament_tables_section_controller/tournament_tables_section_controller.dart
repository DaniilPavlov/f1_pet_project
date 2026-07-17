import 'package:mobx/mobx.dart';

part 'tournament_tables_section_controller.g.dart';

/// MobX-контроллер секции турнирных таблиц.
class TournamentTablesSectionController = TournamentTablesSectionControllerBase
    with _$TournamentTablesSectionController;

/// Переключает активную таблицу между пилотами и конструкторами.
abstract class TournamentTablesSectionControllerBase with Store {
  @observable
  int activeTable = 0;

  /// Устанавливает индекс отображаемой таблицы.
  @action
  void changeActiveTable(int value) {
    activeTable = value;
  }
}
