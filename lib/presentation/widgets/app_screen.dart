import 'package:beamer/beamer.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/app/app_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:flutter/material.dart';

// TODO(pavlov): стек страницы не сохраняется, при переключении все загружается по новой
// нужно внедрить индексд стек и кучу бимеров
class AppScreen extends ElementaryWidget<IAppScreenWM> {
  const AppScreen({
    Key? key,
    WidgetModelFactory wmFactory = defaultAppScreenWMFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAppScreenWM wm) {

    return WillPopScope(
      onWillPop: wm.onPop,
      child: Scaffold(
        // body: Beamer(
        //   key: wm.beamerKey,
        //   routerDelegate: wm.routerDelegate,
        // ),
        body: StateNotifierBuilder<int>(
          listenableState: wm.currentIndexListenable,
          builder: (_, currentIndexListenable) => IndexedStack(
            index: currentIndexListenable,
            children: [
              Beamer(
                key: wm.beamerHomeKey,
                routerDelegate: wm.routerDelegates[0],
              ),
              Beamer(
                key: wm.beamerResultsKey,
                routerDelegate: wm.routerDelegates[1],
              ),
              Beamer(
                key: wm.beamerScheduleKey,
                routerDelegate: wm.routerDelegates[2],
              ),
              Beamer(
                key: wm.beamerHallOfFameKey,
                routerDelegate: wm.routerDelegates[3],
              ),
              Beamer(
                key: wm.beamerCircuitsKey,
                routerDelegate: wm.routerDelegates[4],
              ),
            ],
          ),
        ),
        bottomNavigationBar: StateNotifierBuilder<int>(
          listenableState: wm.currentIndexListenable,
          builder: (_, currentIndexListenable) => NavBar(
            currentIndex: wm.currentIndexListenable.value!,
            onTap: wm.changeIndex,
          ),
        ),
      ),
    );
  }
}
