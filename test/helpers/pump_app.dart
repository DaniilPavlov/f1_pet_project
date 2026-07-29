import 'package:f1_pet_project/common/utils/theme/app_theme_data.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Обёртка для widget/golden-тестов: тема, l10n, фиксированный surface.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    Locale locale = const Locale('en'),
    ThemeData? theme,
    Size surfaceSize = const Size(390, 844),
    bool wrapInScaffold = true,

    /// Оборачивает [MaterialApp] (например Provider выше navigator для modal sheets).
    Widget Function(Widget app)? wrapApp,
  }) async {
    await binding.setSurfaceSize(surfaceSize);
    addTearDown(() => binding.setSurfaceSize(null));

    view.physicalSize = surfaceSize;
    view.devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    Widget app = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppThemeData.light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: wrapInScaffold ? Scaffold(body: widget) : widget,
    );
    if (wrapApp != null) {
      app = wrapApp(app);
    }

    await pumpWidget(app);
    await pump();
  }

  /// Два кадра: layout + первый paint (шиммер успевает получить size).
  Future<void> pumpForGolden() async {
    await pump();
    await pump(const Duration(milliseconds: 16));
  }
}
