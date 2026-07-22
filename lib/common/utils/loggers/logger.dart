import 'package:logger/logger.dart';

/// Единый экземпляр логгера приложения.
///
/// GoF Creational Singleton — один общий экземпляр на всё приложение:
/// импортирующие модули используют тот же `logger`, без повторного создания.
final logger = Logger(
  printer: PrettyPrinter(
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
