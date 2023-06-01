import 'package:f1_pet_project/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

// TODO(pavlov): добавить экран ошибки с возможностью перезагрузки данных
class App extends StatelessWidget {
  App({super.key});

  final _router = AppRouter.router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('ru', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      restorationScopeId: 'app',
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        minWidth: 375,
        defaultScale: true,
      ),
    );
  }
}
