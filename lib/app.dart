import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/common/widgets/force_update_screen.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Корневой виджет: bootstrap + MaterialApp.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final _router = AppRouter();
  var _remindersReady = false;
  var _forceUpdate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lockPortrait();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_bootstrap()));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_onResumed());
    }
  }

  Future<void> _bootstrap() async {
    await _refreshForceUpdateGate();
    if (!mounted) {
      return;
    }
    if (_forceUpdate) {
      await context.read<LocaleController>().load();
      return;
    }
    await _startRemindersIfNeeded();
  }

  Future<void> _onResumed() async {
    if (!mounted) {
      return;
    }
    final remoteConfig = context.read<RemoteConfigService>();
    await remoteConfig.refresh();
    await _refreshForceUpdateGate();
    if (!mounted || _forceUpdate) {
      return;
    }
    await _syncReminders(remoteConfig);
  }

  Future<void> _refreshForceUpdateGate() async {
    if (!mounted) {
      return;
    }
    final required = await context.read<RemoteConfigService>().isUpdateRequired();
    if (mounted && required != _forceUpdate) {
      setState(() => _forceUpdate = required);
    }
  }

  Future<void> _startRemindersIfNeeded() async {
    if (!mounted) {
      return;
    }
    final remoteConfig = context.read<RemoteConfigService>();
    final localeController = context.read<LocaleController>();
    final reminders = context.read<RaceReminderService>();
    await localeController.load();
    if (!mounted) {
      return;
    }

    if (!PlatformCapabilities.hasLocalNotifications || !remoteConfig.localNotificationsEnabled) {
      return;
    }

    try {
      await reminders.init();
      await reminders.requestPermissions();
      await reminders.sync(locale: localeController.locale);
      _remindersReady = true;
    } on Object catch (error, stackTrace) {
      logger.e('App reminders bootstrap failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _syncReminders(RemoteConfigService remoteConfig) async {
    if (!PlatformCapabilities.hasLocalNotifications || !mounted) {
      return;
    }
    final locale = context.read<LocaleController>().locale;
    final reminders = context.read<RaceReminderService>();

    if (!remoteConfig.localNotificationsEnabled) {
      await reminders.sync(locale: locale);
      return;
    }
    if (_remindersReady) {
      await reminders.sync(locale: locale);
    } else {
      await _startRemindersIfNeeded();
    }
  }

  void _lockPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 25, 17, 17),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
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
          routerDelegate: _router.delegate(),
          routeInformationParser: _router.defaultRouteParser(),
          builder: (context, child) => _AppFrame(
            forceUpdate: _forceUpdate,
            child: child,
          ),
        );
      },
    );
  }
}

class _AppFrame extends StatelessWidget {
  const _AppFrame({required this.forceUpdate, required this.child});

  final bool forceUpdate;
  final Widget? child;

  static const _breakpoints = [
    Breakpoint(start: 0, end: 450, name: MOBILE),
    Breakpoint(start: 451, end: 800, name: TABLET),
    Breakpoint(start: 801, end: 1920, name: DESKTOP),
    Breakpoint(start: 1921, end: double.infinity, name: '4K'),
  ];

  @override
  Widget build(BuildContext context) {
    ErrorCopy.sync(AppLocalizations.of(context));
    final media = MediaQuery.of(context);
    final content = forceUpdate
        ? const ForceUpdateScreen()
        : ResponsiveBreakpoints.builder(child: child!, breakpoints: _breakpoints);

    return MediaQuery(
      data: media.copyWith(textScaler: media.textScaler.clamp(maxScaleFactor: 1.2)),
      child: content,
    );
  }
}
