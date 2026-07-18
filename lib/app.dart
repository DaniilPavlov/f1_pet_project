import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Корневой виджет приложения с роутингом и адаптивной вёрсткой.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

/// Состояние приложения: ориентация экрана и системный UI.
class _AppState extends State<App> {
  final _appRouter = AppRouter();

  /// Фиксирует портретную ориентацию и стиль статус-бара.
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 25, 17, 17),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Собирает MaterialApp с auto_route и responsive_framework.
  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();

    return Observer(
      builder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          supportedLocales: LocaleControllerBase.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          builder: (context, child) {
            final data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2)),
              child: ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
