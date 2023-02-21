import 'package:f1_pet_project/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();
  App({super.key});

  @override
  Widget build(BuildContext context) {
    // final mySystemTheme = SystemUiOverlayStyle.light.copyWith(
    //   systemNavigationBarColor: AppTheme.grayBG,
    //   statusBarColor: Colors.black.withOpacity(.3),
    // );

    // SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    return MaterialApp.router(
      supportedLocales: const [
        Locale('ru', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        minWidth: 375,
        defaultScale: true,
      ),
    );
  }
}
