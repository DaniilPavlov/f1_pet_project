import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/router/main_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final routerDelegate = BeamerDelegate(
      initialPath: '/main',
      locationBuilder: BeamerLocationBuilder(
        beamLocations: [
      MainLocation(),
        ],
      ),
    );

    // final routerDelegate = BeamerDelegate(
    //   locationBuilder: RoutesLocationBuilder(
    //     routes: {
    //       '/*': (context, state, data) => AppScreen(),
    //     },
    //   ),
    // );

    // final routerDelegate = BeamerDelegate(
    //   initialPath: '/home',
    //   locationBuilder: BeamerLocationBuilder(
    //     beamLocations: [
    //       HomeLocation(),
    //       ResultsLocation(),
    //       ScheduleLocation(),
    //       HallOfFameLocation(),
    //       CircuitsLocation(),
    //     ],
    //   ),
    // );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('ru', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
        fallbackToBeamBack: false,
      ),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        minWidth: 375,
        defaultScale: true,
      ),
    );
  }
}
