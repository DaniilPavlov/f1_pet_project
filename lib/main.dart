import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AndroidYandexMap.useAndroidViewSurface = false;

  final localeController = LocaleController();
  await localeController.load();

  runApp(Provider<LocaleController>.value(value: localeController, child: const App()));
}
