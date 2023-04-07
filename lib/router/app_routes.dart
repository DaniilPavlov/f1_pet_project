import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:f1_pet_project/presentation/widgets/app_screen.dart';
import 'package:f1_pet_project/router/circuit_routes.dart';
import 'package:f1_pet_project/router/hall_of_fame_routes.dart';
import 'package:f1_pet_project/router/home_routes.dart';
import 'package:f1_pet_project/router/results_routes.dart';
import 'package:f1_pet_project/router/schedule_routes.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRoutes {
  void setup() {
    // enable debug logging for all routes
    QR.settings.enableDebugLog = true;

    // enable auto restoration for all routes
    QR.settings.autoRestoration = true;

    // you can set your own logger
    // QR.settings.logger = (String message) {
    //   print(message);
    // };

    // Set up the not found route in your app.
    // this route (path and view) will be used when the user navigates to a
    // route that does not exist.
    QR.settings.notFoundPage = QRoute(
      path: 'path',
      builder: () => const HomeScreen(),
    );

    // add observers to the app
    // this observer will be called when the user navigates to new route
    QR.observer.onNavigate.add((path, route) async {
      debugPrint('Observer: Navigating to $path');
    });

    // this observer will be called when the popped out from a route
    QR.observer.onPop.add((path, route) async {
      debugPrint('Observer: popping out from $path');
    });

    // create initial route that will be used when the app is started
    // or when route is waiting for response
    //QR.settings.iniPage = InitPage();

    // Change the page transition for all routes in your app.
    QR.settings.pagesType = const QFadePage();
  }

  List<QRoute> routes() => [
        QRoute.withChild(
          name: 'App',
          path: '/',
          builderChild: AppScreen.new,
          initRoute: 'home',
          children: [
            HomeRoutes().routes(),
            ResultsRoutes().routes(),
            ScheduleRoutes().routes(),
            HallOfFameRoutes().routes(),
            CircuitRoutes().routes(),
          ],
        ),
      ];
}
