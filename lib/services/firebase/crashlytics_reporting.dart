import 'dart:io';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';

/// Сетевые/временные ошибки не отправляем в Crashlytics — они не баги приложения.
bool shouldReportUncaughtErrorToCrashlytics(Object error) {
  if (_isBenignNetworkError(error)) {
    return false;
  }

  if (error is CustomException) {
    final parent = error.parentException;
    if (parent != null && _isBenignNetworkError(parent)) {
      return false;
    }
  }

  return true;
}

bool _isBenignNetworkError(Object error) {
  return error is DioException ||
      error is SocketException ||
      error is HttpException ||
      error is TlsException ||
      error is HandshakeException;
}
