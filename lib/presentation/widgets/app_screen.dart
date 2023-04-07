import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/app/app_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppScreen extends ElementaryWidget<IAppScreenWM> {
  final QRouter router;
  const AppScreen(
    this.router, {
    Key? key,
    WidgetModelFactory wmFactory = defaultAppScreenWMFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAppScreenWM wm) {
    return WillPopScope(
      onWillPop: wm.onPop,
      child: Scaffold(
        // TODO(pavlov): не работает навигация внутри секций
        // они могут только переключаться
        body: StateNotifierBuilder<int>(
          listenableState: wm.currentIndexListenable,
          builder: (_, currentIndexListenable) => router,
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
