import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/exceptions/success_false.dart';

/// Обёртка над асинхронной операцией: retry, before/after, onSuccess/onError.
///
/// GoF Behavioral Template Method — фиксированный скелет алгоритма
/// (`before` → retry/`processing` → `after` → `onSuccess`/`onError`);
/// вызывающий подставляет только переменные шаги.
///
/// Порядок: [before] → [processing] (с повторами) → [after] → [onSuccess]/[onError].
///
/// [maxAttempts] по умолчанию 1; сетевые экраны через [runAsyncLoad] обычно ставят 3.
Future<void> execute<T>(
  Future<T> Function() processing, {
  String? dioErrorText,
  String? responseParseErrorText,
  String? otherErrorText,
  FutureOr<void> Function()? before,
  FutureOr<void> Function()? after,
  FutureOr<void> Function(T? data)? onSuccess,
  FutureOr<void> Function(CustomException e)? onError,
  int maxAttempts = 1,
  Duration Function(int attempt)? attemptsDelayCallback,
}) async {
  final attemptsDelay = attemptsDelayCallback ?? _defaultAttemptsDelay;

  CustomException? ex;
  T? data;
  var currentAttempt = 0;

  await before?.call();

  while (currentAttempt < maxAttempts) {
    (data, ex) = await _process<T>(
      processing,
      dioErrorText: dioErrorText,
      responseParseErrorText: responseParseErrorText,
      otherErrorText: otherErrorText,
    );

    currentAttempt += 1;

    if (ex == null || currentAttempt >= maxAttempts || !_shouldRetry(ex)) {
      break;
    }

    await Future<void>.delayed(attemptsDelay(currentAttempt));
  }

  await after?.call();

  if (ex != null) {
    _logException(ex);
    await onError?.call(ex);
  } else {
    return await onSuccess?.call(data);
  }
}

Duration Function(int attempt) _defaultAttemptsDelay = (attempt) => const Duration(milliseconds: 500);

String? _lastLoggedErrorKey;
int _duplicateErrorCount = 0;

/// Пишет ошибку в лог один раз; повторы той же ошибки схлопывает.
void _logException(CustomException ex) {
  final key = '${ex.title}|${ex.subtitle}';
  if (key == _lastLoggedErrorKey) {
    _duplicateErrorCount++;
    return;
  }

  if (_duplicateErrorCount > 0) {
    log('(повторов предыдущей ошибки: $_duplicateErrorCount)');
  }
  _lastLoggedErrorKey = key;
  _duplicateErrorCount = 0;

  final skipStack = ex.parentException is DioException;
  if (skipStack) {
    log('${ex.title}: ${ex.subtitle}');
  } else {
    log('${ex.title}: ${ex.subtitle}', stackTrace: ex.stackTrace);
  }
}

/// Повторяем только сетевые/временные Dio-ошибки. Parse и прочее — сразу fail.
bool _shouldRetry(CustomException ex) {
  final parent = ex.parentException;
  if (parent is! DioException) {
    return false;
  }

  final status = parent.response?.statusCode;
  if (status == null) {
    return true;
  }

  if (status == 408 || status == 425) {
    return true;
  }

  return status >= 500;
}

/// Функция, которая производит один вызов [processing].
Future<(T?, CustomException?)> _process<T>(
  Future<T> Function() processing, {
  String? dioErrorText,
  String? responseParseErrorText,
  String? otherErrorText,
}) async {
  CustomException? ex;
  T? data;

  try {
    data = await processing();
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    final isConnectionIssue =
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown;
    if (isConnectionIssue) {
      ex = CustomException(
        title: ErrorCopy.noConnection,
        subtitle: ErrorCopy.noConnectionSubtitle,
        parentException: e,
        stackTrace: e.stackTrace,
      );
    } else if (status == 429) {
      ex = CustomException(
        title: ErrorCopy.tooManyRequests,
        subtitle: ErrorCopy.tooManyRequestsSubtitle,
        parentException: e,
        stackTrace: e.stackTrace,
      );
    } else {
      ex = CustomException(
        title: dioErrorText ?? ErrorCopy.requestError,
        subtitle: e.message,
        parentException: e,
        stackTrace: e.stackTrace,
      );
    }
  } on ResponseParseException catch (e) {
    ex = CustomException(
      title: responseParseErrorText ?? ErrorCopy.responseParseError,
      subtitle: e.toString(),
      stackTrace: e.stackTrace,
    );
  } on SuccessFalse catch (e) {
    ex = CustomException(title: e.toString(), stackTrace: e.stackTrace);
  } catch (e) {
    ex = CustomException(
      title: otherErrorText ?? ErrorCopy.unexpectedError,
      subtitle: e.toString(),
      stackTrace: StackTrace.current,
    );
  }

  return (data, ex);
}
