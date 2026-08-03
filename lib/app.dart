import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme_data.dart';
import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/common/widgets/force_update_screen.dart';
import 'package:f1_pet_project/core/profile/controllers/notifications_preference_controller/notifications_preference_controller.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/analytics/analytics_navigation_observer.dart';
import 'package:f1_pet_project/services/deeplinks/f1pet_deep_link_handler.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_sync_service.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
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
  late final AppRouter _router;
  late final AnalyticsGateway _analytics;
  var _remindersReady = false;
  var _routerInitialized = false;
  var _forceUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_routerInitialized) {
      _analytics = context.read<AnalyticsGateway>();
      _router = AppRouter();
      _routerInitialized = true;
    }
  }

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
    if (!mounted) {
      return;
    }
    context.read<LiveWeekendController>().onAppLifecycleChanged(state);
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
      await Future.wait([context.read<LocaleController>().load(), context.read<ThemeController>().load()]);
      return;
    }
    await Future.wait([_startRemindersIfNeeded(), _syncHomeWidgets()]);
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
    await Future.wait([_syncReminders(), _syncHomeWidgets()]);
  }

  Future<void> _syncHomeWidgets() async {
    if (!PlatformCapabilities.hasHomeWidgets || !mounted) {
      return;
    }
    try {
      await context.read<AppWidgetSyncService>().sync();
    } on Object catch (error, stackTrace) {
      logger.e('App home widget sync failed', error: error, stackTrace: stackTrace);
    }
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
    final localeController = context.read<LocaleController>();
    final themeController = context.read<ThemeController>();
    final reminders = context.read<RaceReminderService>();
    final notificationPrefs = context.read<NotificationsPreferenceController>();
    await Future.wait([
      localeController.load(),
      themeController.load(),
      notificationPrefs.load(),
    ]);
    if (!mounted) {
      return;
    }

    if (!PlatformCapabilities.hasLocalNotifications) {
      return;
    }

    if (!notificationPrefs.userEnabled) {
      return;
    }

    try {
      await reminders.init();
      await reminders.requestPermissions();
      await reminders.sync(
        locale: localeController.locale,
        includePractices: notificationPrefs.practiceRemindersEnabled,
      );
      _remindersReady = true;
    } on Object catch (error, stackTrace) {
      logger.e('App reminders bootstrap failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _syncReminders() async {
    if (!PlatformCapabilities.hasLocalNotifications || !mounted) {
      return;
    }
    final locale = context.read<LocaleController>().locale;
    final reminders = context.read<RaceReminderService>();
    final notificationPrefs = context.read<NotificationsPreferenceController>();

    if (!notificationPrefs.userEnabled) {
      await reminders.cancelAll();
      return;
    }
    if (_remindersReady) {
      await reminders.sync(
        locale: locale,
        includePractices: notificationPrefs.practiceRemindersEnabled,
      );
    } else {
      await _startRemindersIfNeeded();
    }
  }

  void _lockPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();
    final themeController = context.read<ThemeController>();

    return Observer(
      builder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemeData.light(),
          darkTheme: AppThemeData.dark(),
          themeMode: themeController.themeMode,
          locale: localeController.locale,
          supportedLocales: LocaleControllerBase.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerDelegate: _router.delegate(navigatorObservers: () => [AnalyticsNavigationObserver(_analytics)]),
          routeInformationParser: _router.defaultRouteParser(),
          builder: (context, child) => _AppFrame(
            forceUpdate: _forceUpdate,
            router: _router,
            child: child,
          ),
        );
      },
    );
  }
}

class _AppFrame extends StatelessWidget {
  const _AppFrame({required this.forceUpdate, required this.router, required this.child});

  final bool forceUpdate;
  final AppRouter router;
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.chrome,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MediaQuery(
        data: media,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: Stack(
            children: [
              content,
              F1PetDeepLinkHandler(forceUpdate: forceUpdate, router: router),
            ],
          ),
        ),
      ),
    );
  }
}
