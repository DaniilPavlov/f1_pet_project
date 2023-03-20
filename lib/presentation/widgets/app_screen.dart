import 'package:beamer/beamer.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/app/app_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:flutter/material.dart';

// TODO(pavlov): навигация не работает
// переделать в IndexedStack
class AppScreen extends ElementaryWidget<IAppScreenWM> {
  const AppScreen({
    Key? key,
    WidgetModelFactory wmFactory = defaultAppScreenWMFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAppScreenWM wm) {
     final beamerKey = GlobalKey<BeamerState>();
    return Scaffold(
      // body: StateNotifierBuilder<int>(
      //   listenableState: wm.currentIndexListenable,
      //   builder: (_, currentIndexListenable) => IndexedStack(
      //     index: currentIndexListenable,
      //     children: const [
      //       HomeScreen(),
      //       ResultsScreen(),
      //       ScheduleScreen(),
      //       HallOfFameScreen(),
      //       CircuitsScreen(),
      //     ],
      //   ),
      // ),
      body: Beamer(
        key: beamerKey,
        routerDelegate: wm.routerDelegate,
      ),
      bottomNavigationBar: StateNotifierBuilder<int>(
        listenableState: wm.currentIndexListenable,
        builder: (_, currentIndexListenable) => NavBar(
          currentIndex: wm.currentIndexListenable.value!,
          onTap: wm.changeIndex,
        ),
      ),
    );
  }
}
