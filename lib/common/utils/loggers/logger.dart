import 'package:f1_pet_project/common/debug_tools/debug_tools_helper.dart';
import 'package:f1_pet_project/common/debug_tools/talker_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Единый экземпляр логгера приложения (только в debug / debug tools).
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
    if (!kDebugMode && !DebugToolsHelper.isEnabled) {
      return;
    }
    if (kDebugMode) {
      _delegate.d(message, time: time, error: error, stackTrace: stackTrace);
    }
    if (DebugToolsHelper.isEnabled) {
      TalkerRepository.talker.debug(message, error, stackTrace);
    }
  }

  void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode && !DebugToolsHelper.isEnabled) {
      return;
    }
    if (kDebugMode) {
      _delegate.w(message, time: time, error: error, stackTrace: stackTrace);
    }
    if (DebugToolsHelper.isEnabled) {
      TalkerRepository.talker.warning(message, error, stackTrace);
    }
  }

  void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode && !DebugToolsHelper.isEnabled) {
      return;
    }
    if (kDebugMode) {
      _delegate.e(message, time: time, error: error, stackTrace: stackTrace);
    }
    if (DebugToolsHelper.isEnabled) {
      TalkerRepository.talker.error(message, error, stackTrace);
    }
  }
}
