import 'dart:async';

import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AndroidYandexMap.useAndroidViewSurface = false;

  final localeController = LocaleController();
  await localeController.load();

  final scheduleRepository = ScheduleRepository();
  final raceReminderService = RaceReminderService(scheduleRepository: scheduleRepository);
  await raceReminderService.init();
  // Не блокируем старт UI ожиданием сети: sync сам ловит ошибки и падает на кэш.
  unawaited(raceReminderService.sync(locale: localeController.locale));

  runApp(
    MultiProvider(
      providers: [
        Provider<LocaleController>.value(value: localeController),
        Provider<ScheduleRepository>.value(value: scheduleRepository),
        Provider<RaceReminderService>.value(value: raceReminderService),
      ],
      child: const App(),
    ),
  );
}
