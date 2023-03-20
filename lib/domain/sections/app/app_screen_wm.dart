import 'package:beamer/beamer.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/app/app_screen_model.dart';
import 'package:f1_pet_project/presentation/widgets/app_screen.dart';
import 'package:f1_pet_project/router/circuits_location.dart';

import 'package:f1_pet_project/router/hall_of_fame_location.dart';
import 'package:f1_pet_project/router/home_location.dart';
import 'package:f1_pet_project/router/results_location.dart';
import 'package:f1_pet_project/router/schedule_location.dart';
import 'package:flutter/material.dart';

abstract class IAppScreenWM extends IWidgetModel {
  BeamerDelegate get routerDelegate;

  ListenableState<int> get currentIndexListenable;

  void changeIndex(int index);
}

class AppScreenWM extends WidgetModel<AppScreen, AppScreenModel>
    implements IAppScreenWM {
  final _currentIndexState = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get currentIndexListenable => _currentIndexState;

  @override
  BeamerDelegate get routerDelegate => BeamerDelegate(
        initialPath: '/results',
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

  // @override
  // List<BeamerDelegate> get routerDelegate => [
  //       BeamerDelegate(
  //         initialPath: '/home',
  //         locationBuilder: (routeInformation, _) {
  //           return HomeLocation();
  //         },
  //       ),
  //       BeamerDelegate(
  //         initialPath: '/results',
  //         locationBuilder: (routeInformation, _) {
  //           return ResultsLocation();
  //         },
  //       ),
  //       BeamerDelegate(
  //         initialPath: '/schedule',
  //         locationBuilder: (routeInformation, _) {
  //           return ScheduleLocation();
  //         },
  //       ),
  //       BeamerDelegate(
  //         initialPath: '/hall_of_fame',
  //         locationBuilder: (routeInformation, _) {
  //           return HallOfFameLocation();
  //         },
  //       ),
  //       BeamerDelegate(
  //         initialPath: '/circuits',
  //         locationBuilder: (routeInformation, _) {
  //           return CircuitsLocation();
  //         },
  //       ),
  //     ];

  AppScreenWM(AppScreenModel model) : super(model);

  // @override
  // void initWidgetModel() {
  //   super.initWidgetModel();
  // }

  @override
  void changeIndex(int index) {
    _currentIndexState.accept(index);

    // switch (index) {
    //   case 0:
    //     Beamer.of(context).beamToNamed('/home');
    //     break;
    //   case 2:
    //     Beamer.of(context).beamToNamed('/schedule');
    //     break;
    //   default:
    // }

    // _beamerState.accept(_routerDelegate[index]);
    // _routerDelegate[index].update(rebuild: false);
  }
}

AppScreenWM defaultAppScreenWMFactory(BuildContext _) =>
    AppScreenWM(AppScreenModel());
