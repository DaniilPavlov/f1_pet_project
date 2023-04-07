import 'package:f1_pet_project/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

// TODO(pavlov): добавить экран ошибки с возможностью перезагрузки данных
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoutes = AppRoutes()..setup();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('ru', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(appRoutes.routes()),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        minWidth: 375,
        defaultScale: true,
      ),
    );
  }
}
