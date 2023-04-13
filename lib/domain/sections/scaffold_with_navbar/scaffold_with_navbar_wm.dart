import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/scaffold_with_navbar/scaffold_with_navbar_model.dart';
import 'package:f1_pet_project/presentation/widgets/scaffold_with_navbar.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBarWM
    extends WidgetModel<ScaffoldWithNavBar, ScaffoldWithNavBarModel>
    implements IScaffoldWithNavBarWM {
  final _currentIndexState = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get currentIndexListenable => _currentIndexState;

  DateTime? _currentBackPressTime;

  ScaffoldWithNavBarWM(ScaffoldWithNavBarModel model) : super(model);

  @override
  Future<bool> onPop() {
    if (ModalRoute.of(context)!.settings.name != '/home') {
      context.go('/home');
      return Future.value(false);
    } else {
      final currentTime = DateTime.now();
      if (_currentBackPressTime == null ||
          currentTime.difference(_currentBackPressTime ?? DateTime.now()) >
              const Duration(seconds: 1)) {
        _currentBackPressTime = currentTime;
        Fluttertoast.showToast(
          msg: 'Нажмите еще раз для выхода',
          backgroundColor: AppTheme.red,
        );
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  @override
  void changeIndex(int index) {
    _currentIndexState.accept(index);

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/results');
        break;
      case 2:
        context.go('/schedule');
        break;
      case 3:
        context.go('/hall_of_fame');
        break;
      case 4:
        context.go('/circuits');
        break;
      default:
        context.go('/home');
        break;
    }
  }
}

ScaffoldWithNavBarWM defaultAppScreenWMFactory(BuildContext _) =>
    ScaffoldWithNavBarWM(ScaffoldWithNavBarModel());

abstract class IScaffoldWithNavBarWM extends IWidgetModel {
  /// Returns current nav bar index.
  ListenableState<int> get currentIndexListenable;

  /// Changes nav bar index.
  void changeIndex(int index);

  /// Decides pop page or not.
  Future<bool> onPop();
}
