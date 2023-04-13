import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/scaffold_with_navbar/scaffold_with_navbar_wm.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:flutter/material.dart';

class ScaffoldWithNavBar extends ElementaryWidget<IScaffoldWithNavBarWM> {
  final Widget child;
  const ScaffoldWithNavBar({
    required this.child,
    Key? key,
    WidgetModelFactory wmFactory = defaultAppScreenWMFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IScaffoldWithNavBarWM wm) {
    return WillPopScope(
      onWillPop: wm.onPop,
      child: Scaffold(
        // body: Beamer(
        //   key: wm.beamerKey,
        //   routerDelegate: wm.routerDelegate,
        // ),
        body: StateNotifierBuilder<int>(
          listenableState: wm.currentIndexListenable,
          builder: (_, currentIndexListenable) => child,
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
