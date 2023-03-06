import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/certain_race/certain_race_screen_model.dart';
import 'package:f1_pet_project/presentation/sections/results/certain_race/certain_race_screen.dart';
import 'package:flutter/material.dart';

abstract class ICertainRaceScreenWM extends IWidgetModel {
  // год
  TextEditingController get yearController;

  // раунд
  TextEditingController get roundController;

  void onPop();
}

class CertainRaceScreenWM
    extends WidgetModel<CertainRaceScreen, CertainRaceScreenModel>
    implements ICertainRaceScreenWM {
  final _yearController = TextEditingController();

  final _roundController = TextEditingController();

  @override
  TextEditingController get yearController => _yearController;

  @override
  TextEditingController get roundController => _roundController;

  CertainRaceScreenWM(super.model);

  @override
  void onPop() {
    context.router.removeLast();
  }
}

CertainRaceScreenWM createCertainRaceScreenWM(BuildContext _) =>
    CertainRaceScreenWM(CertainRaceScreenModel());
