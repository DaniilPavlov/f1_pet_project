import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/app/app_screen_model.dart';
import 'package:f1_pet_project/presentation/widgets/app_screen.dart';

import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppScreenWM extends WidgetModel<AppScreen, AppScreenModel>
    implements IAppScreenWM {
  final _currentIndexState = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get currentIndexListenable => _currentIndexState;

  DateTime? _currentBackPressTime;

  AppScreenWM(AppScreenModel model) : super(model);

  @override
  Future<bool> onPop() {
    if (QR.currentPath != '/home') {
      QR.to('/home',pageAlreadyExistAction: PageAlreadyExistAction.BringToTop);
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
        QR.to('/home',
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop,);
        break;
      case 1:
        QR.to('/results',
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop,);

        break;
      case 2:
        QR.to('/schedule',
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop,);

        break;
      case 3:
        QR.to('/hall_of_fame',
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop,);

        break;
      case 4:
        QR.to('/circuits',
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop,);

        break;
      default:
        QR.to('/home',
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop,);

        break;
    }
  }
}

AppScreenWM defaultAppScreenWMFactory(BuildContext _) =>
    AppScreenWM(AppScreenModel());

abstract class IAppScreenWM extends IWidgetModel {
  /// Returns current bottom section.
  ListenableState<int> get currentIndexListenable;

  /// Changes nav bar index.
  void changeIndex(int index);

  /// Decides pop page or not.
  Future<bool> onPop();
}
