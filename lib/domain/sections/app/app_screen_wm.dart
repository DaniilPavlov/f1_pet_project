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

  final _beamerHomeKey = GlobalKey<BeamerState>();
  final _beamerResultsKey = GlobalKey<BeamerState>();
  final _beamerScheduleKey = GlobalKey<BeamerState>();
  final _beamerHallOfFameKey = GlobalKey<BeamerState>();
  final _beamerCircuitsKey = GlobalKey<BeamerState>();

  @override
  GlobalKey<BeamerState> get beamerHomeKey => _beamerHomeKey;

  @override
  GlobalKey<BeamerState> get beamerResultsKey => _beamerResultsKey;

  @override
  GlobalKey<BeamerState> get beamerScheduleKey => _beamerScheduleKey;

  @override
  GlobalKey<BeamerState> get beamerHallOfFameKey => _beamerHallOfFameKey;

  @override
  GlobalKey<BeamerState> get beamerCircuitsKey => _beamerCircuitsKey;

  @override
  ListenableState<int> get currentIndexListenable => _currentIndexState;

  @override
  List<BeamerDelegate> get routerDelegates => [
        BeamerDelegate(
          initialPath: '/home',
          locationBuilder: (routeInformation, _) {
            if (routeInformation.location!.contains('home')) {
              return HomeLocation();
            }
            return NotFound(path: routeInformation.location!);
          },
        ),
        BeamerDelegate(
          initialPath: '/results',
          locationBuilder: (routeInformation, _) {
            if (routeInformation.location!.contains('results')) {
              return ResultsLocation();
            }
            return NotFound(path: routeInformation.location!);
          },
        ),
        BeamerDelegate(
          initialPath: '/schedule',
          locationBuilder: (routeInformation, _) {
            if (routeInformation.location!.contains('schedule')) {
              return ScheduleLocation();
            }
            return NotFound(path: routeInformation.location!);
          },
        ),
        BeamerDelegate(
          initialPath: '/hall_of_fame',
          locationBuilder: (routeInformation, _) {
            if (routeInformation.location!.contains('hall_of_fame')) {
              return HallOfFameLocation();
            }
            return NotFound(path: routeInformation.location!);
          },
        ),
        BeamerDelegate(
          initialPath: '/circuits',
          locationBuilder: (routeInformation, _) {
            if (routeInformation.location!.contains('circuits')) {
              return CircuitsLocation();
            }
            return NotFound(path: routeInformation.location!);
          },
        ),
      ];

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
    if (_beamerHomeKey.currentState?.routerDelegate.currentBeamLocation.state
            .routeInformation.location !=
        '/home') {
      _beamerHomeKey.currentState?.routerDelegate.beamToNamed('/home');
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
    routerDelegates[index].update(rebuild: false);
    switch (index) {
      case 0:
        _beamerHomeKey.currentState?.routerDelegate.beamToNamed('/home');
        break;
      case 1:
        _beamerHomeKey.currentState?.routerDelegate.beamToNamed('/results');
        break;
      case 2:
        _beamerHomeKey.currentState?.routerDelegate.beamToNamed('/schedule');
        break;
      case 3:
        _beamerHomeKey.currentState?.routerDelegate
            .beamToNamed('/hall_of_fame');
        break;
      case 4:
        _beamerHomeKey.currentState?.routerDelegate.beamToNamed('/circuits');
        break;
      default:
        _beamerHomeKey.currentState?.routerDelegate.beamToNamed('/home');
        break;
    }
  }
}

AppScreenWM defaultAppScreenWMFactory(BuildContext _) =>
    AppScreenWM(AppScreenModel());

abstract class IAppScreenWM extends IWidgetModel {
  /// Returns beamer delegate.
  BeamerDelegate get routerDelegate;

  List<BeamerDelegate> get routerDelegates;

  /// Returns current nav bar index.
  ListenableState<int> get currentIndexListenable;

  /// Returns beamer key.
  GlobalKey<BeamerState> get beamerHomeKey;

  /// Returns beamer key.
  GlobalKey<BeamerState> get beamerResultsKey;

  /// Returns beamer key.
  GlobalKey<BeamerState> get beamerScheduleKey;

  /// Returns beamer key.
  GlobalKey<BeamerState> get beamerHallOfFameKey;

  /// Returns beamer key.
  GlobalKey<BeamerState> get beamerCircuitsKey;

  /// Changes nav bar index.
  void changeIndex(int index);

  /// Decides pop page or not.
  Future<bool> onPop();
}
