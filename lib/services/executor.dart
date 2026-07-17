import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/exceptions/success_false.dart';

/// Функция, в которую следует обернуть отправку запроса.
///
/// [processing] - наша функция, которую мы оборачиваем.
///
/// [dioErrorText], [responseParseErrorText], [otherErrorText] - тексты ошибок.
///
/// [before] - коллбек, который запускается единожды перед запуском [processing].
///
/// [after] - коллбек, который запускается всегда единожды после [processing], но до [onError] и [onSuccess].
///
/// [onSuccess] - коллбек, который запускается если не была отловлена никакая ошибка.
///
/// [onError] - коллбек, который запускается если была отловлена ошибка.
///
/// [maxAttempts] - количество попыток. По-дефолту: 1.
///
/// [attemptsDelayCallback] - коллбек с задержкой между попытками.
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

/// Клиентские 4xx (включая 429) не ретраим — повтор только усугубляет лимит.
bool _shouldRetry(CustomException ex) {
  final parent = ex.parentException;
  if (parent is! DioException) {
    return true;
  }

  final status = parent.response?.statusCode;
  if (status == null) {
    return true;
  }

  if (status == 408 || status == 425) {
    return true;
  }

  return status < 400 || status >= 500;
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
    if (e.type == DioExceptionType.unknown) {
      ex = CustomException(
        title: 'Соединение отсутствует',
        subtitle: 'Как только соединение восстановится, вы снова сможете пользоваться приложением',
        parentException: e,
        stackTrace: e.stackTrace,
      );
    } else if (status == 429) {
      ex = CustomException(
        title: 'Слишком много запросов',
        subtitle: 'API временно ограничивает частоту. Подождите немного и попробуйте снова.',
        parentException: e,
        stackTrace: e.stackTrace,
      );
    } else {
      ex = CustomException(
        title: dioErrorText ?? 'Ошибка при отправке запроса',
        subtitle: e.message,
        parentException: e,
        stackTrace: e.stackTrace,
      );
    }
  } on ResponseParseException catch (e) {
    ex = CustomException(
      title: responseParseErrorText ?? 'Ошибка при обработке ответа от сервера',
      subtitle: e.toString(),
      stackTrace: e.stackTrace,
    );
  } on SuccessFalse catch (e) {
    ex = CustomException(title: e.toString(), stackTrace: e.stackTrace);
  } catch (e) {
    ex = CustomException(
      title: otherErrorText ?? 'Непредвиденная ошибка',
      subtitle: e.toString(),
      stackTrace: StackTrace.current,
    );
  }

  return (data, ex);
}
