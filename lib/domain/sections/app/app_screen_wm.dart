import 'package:beamer/beamer.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/app/app_screen_model.dart';
import 'package:f1_pet_project/presentation/widgets/app_screen.dart';
import 'package:f1_pet_project/router/circuits_location.dart';

import 'package:f1_pet_project/router/hall_of_fame_location.dart';
import 'package:f1_pet_project/router/home_location.dart';
import 'package:f1_pet_project/router/results_location.dart';
import 'package:f1_pet_project/router/schedule_location.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppScreenWM extends WidgetModel<AppScreen, AppScreenModel>
    implements IAppScreenWM {
  final _currentIndexState = StateNotifier<int>(initValue: 0);

  final _beamerKey = GlobalKey<BeamerState>();

  @override
  GlobalKey<BeamerState> get beamerKey => _beamerKey;

  @override
  ListenableState<int> get currentIndexListenable => _currentIndexState;



  @override
  BeamerDelegate get routerDelegate => BeamerDelegate(
        initialPath: '/home',
        locationBuilder: BeamerLocationBuilder(
          beamLocations: [
            HomeLocation(),
            ResultsLocation(),
            ScheduleLocation(),
            HallOfFameLocation(),
            CircuitsLocation(),
          ],
        ),
      );

  DateTime? _currentBackPressTime;

  AppScreenWM(AppScreenModel model) : super(model);

  @override
  Future<bool> onPop() {
    if (_beamerKey.currentState?.routerDelegate.currentBeamLocation.state
            .routeInformation.location !=
        '/home') {
      _beamerKey.currentState?.routerDelegate.beamToNamed('/home');
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
    debugPrint(index.toString());

    _currentIndexState.accept(index);
    switch (index) {
      case 0:
        _beamerKey.currentState?.routerDelegate.beamToNamed('/home');
        break;
      case 1:
        _beamerKey.currentState?.routerDelegate.beamToNamed('/results');
        break;
      case 2:
        _beamerKey.currentState?.routerDelegate.beamToNamed('/schedule');
        break;
      case 3:
        _beamerKey.currentState?.routerDelegate.beamToNamed('/hall_of_fame');
        break;
      case 4:
        _beamerKey.currentState?.routerDelegate.beamToNamed('/circuits');
        break;
      default:
        _beamerKey.currentState?.routerDelegate.beamToNamed('/home');
        break;
    }
  }
}

AppScreenWM defaultAppScreenWMFactory(BuildContext _) =>
    AppScreenWM(AppScreenModel());

abstract class IAppScreenWM extends IWidgetModel {
  /// Returns beamer delegate.
  BeamerDelegate get routerDelegate;

  /// Returns current nav bar index.
  ListenableState<int> get currentIndexListenable;

  /// Returns beamer key.
  GlobalKey<BeamerState> get beamerKey;

  /// Changes nav bar index.
  void changeIndex(int index);

  /// Decides pop page or not.
  Future<bool> onPop();
}
