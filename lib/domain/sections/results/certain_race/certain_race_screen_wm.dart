import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/certain_race/certain_race_screen_model.dart';
import 'package:f1_pet_project/presentation/sections/results/certain_race/certain_race_screen.dart';
import 'package:flutter/material.dart';

abstract class ICertainRaceScreenWM extends IWidgetModel {}

class CertainRaceScreenWM
    extends WidgetModel<CertainRaceScreen, CertainRaceScreenModel>
    implements ICertainRaceScreenWM {
  CertainRaceScreenWM(super.model);
}

CertainRaceScreenWM createCertainRaceScreenWM(BuildContext _) =>
    CertainRaceScreenWM(CertainRaceScreenModel());
