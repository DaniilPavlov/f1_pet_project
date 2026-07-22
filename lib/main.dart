import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_media_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hybrid Composition (default) — Virtual Display often shows a grey map in release.
  AndroidYandexMap.useAndroidViewSurface = true;

  final scheduleRepository = ScheduleRepository();
  final seasonsRepository = SeasonsRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => LocaleController()),
        Provider<ScheduleRepository>.value(value: scheduleRepository),
        Provider<SeasonsRepository>.value(value: seasonsRepository),
        Provider(create: (_) => EspnMediaRepository()),
        Provider(
          create: (_) => RaceReminderService(scheduleRepository: scheduleRepository),
        ),
      ],
      child: const App(),
    ),
  );
}
