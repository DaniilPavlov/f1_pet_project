import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Единый экземпляр логгера приложения (только в debug).
///
/// GoF Creational Singleton — один общий экземпляр на всё приложение:
/// импортирующие модули используют тот же `logger`, без повторного создания.
final logger = AppLogger();

final class AppLogger {
  AppLogger();

  static final Logger _delegate = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) {
      return;
    }
    _delegate.d(message, time: time, error: error, stackTrace: stackTrace);
  }

  void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) {
      return;
    }
    _delegate.w(message, time: time, error: error, stackTrace: stackTrace);
  }

  void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) {
      return;
    }
    _delegate.e(message, time: time, error: error, stackTrace: stackTrace);
  }
}
