import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/scaffold_with_navbar/scaffold_with_navbar_wm.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends ElementaryWidget<IScaffoldWithNavBarWM> {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
    WidgetModelFactory wmFactory = defaultAppScreenWMFactory,
  }) : super(
          wmFactory,
          key: key ?? const ValueKey<String>('ScaffoldWithNavBar'),
        );

  @override
  Widget build(IScaffoldWithNavBarWM wm) {
    return WillPopScope(
      onWillPop: wm.onPop,
      child: Scaffold(
        body: StateNotifierBuilder<int>(
          listenableState: wm.currentIndexListenable,
          builder: (_, currentIndexListenable) => navigationShell,
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
