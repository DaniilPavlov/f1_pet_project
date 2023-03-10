import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/race_info_screen_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class IRaceInfoScreenWM extends IWidgetModel {
  /// показываем ли аппбар таблицы результатов
  ListenableState<bool> get appBarPinned;

  /// проверка видимости таблицы
  void onTableVisibilityChanged(VisibilityInfo info);

  /// закрытие страницы
  void onPop();
}

class RaceInfoScreenWM extends WidgetModel<RaceInfoScreen, RaceInfoScreenModel>
    implements IRaceInfoScreenWM {
  final _appBarPinned = StateNotifier<bool>(initValue: true);

  @override
  ListenableState<bool> get appBarPinned => _appBarPinned;

  RaceInfoScreenWM(RaceInfoScreenModel model) : super(model);

  @override
  void onPop() => context.router.removeLast();

  @override
  void onTableVisibilityChanged(VisibilityInfo info) {
    _appBarPinned.accept(info.visibleBounds.top < info.size.height - 80 &&
        info.visibleBounds.right != 0);
  }
}

RaceInfoScreenWM createRaceInfoScreenWM(BuildContext context) {
  return RaceInfoScreenWM(RaceInfoScreenModel());
}
