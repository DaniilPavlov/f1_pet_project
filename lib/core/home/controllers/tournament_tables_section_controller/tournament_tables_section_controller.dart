import 'package:mobx/mobx.dart';

part 'tournament_tables_section_controller.g.dart';

class TournamentTablesSectionController = TournamentTablesSectionControllerBase
    with _$TournamentTablesSectionController;

abstract class TournamentTablesSectionControllerBase with Store {
  @observable
  int activeTable = 0;

  @action
  void changeActiveTable(int value) {
    activeTable = value;
  }
}
