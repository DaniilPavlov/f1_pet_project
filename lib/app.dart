import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/presentation/widgets/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

// TODO(pavlov): добавить экран ошибки с возможностью перезагрузки данных
class App extends StatelessWidget {
  App({super.key});

  final _routerDelegate = BeamerDelegate(
    initialPath: '/home',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => const AppScreen(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('ru', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerDelegate: _routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: _routerDelegate,
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
