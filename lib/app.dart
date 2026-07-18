import 'dart:async';

import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
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

/// Состояние приложения: ориентация, системный UI, старт напоминаний.
class _AppState extends State<App> with WidgetsBindingObserver {
  final _appRouter = AppRouter();
  var _remindersReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 25, 17, 17),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    // Permissions/init после первого кадра — иначе в release возможен вечный splash.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_bootstrapReminders());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _bootstrapReminders() async {
    if (!mounted) {
      return;
    }

    final localeController = context.read<LocaleController>();
    final reminders = context.read<RaceReminderService>();

    try {
      await localeController.load();
      await reminders.init();
      await reminders.requestPermissions();
      await reminders.sync(locale: localeController.locale);
      _remindersReady = true;
    } on Object catch (error, stackTrace) {
      debugPrint('App bootstrap failed: $error\n$stackTrace');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted || !_remindersReady) {
      return;
    }
    final locale = context.read<LocaleController>().locale;
    unawaited(context.read<RaceReminderService>().sync(locale: locale));
  }

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
