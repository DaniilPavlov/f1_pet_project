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
/// [attemptsDelayCallback] - коллбекс с задержкой между попытками.
/// При вызове прокидывает текущую попытку и на основании ее можно уменьшать.
/// или увеличивать количество времени на попытку.
/// По-дефолту: const Duration(milliseconds: 250).
Future<void> execute<T>(
  Future<T> Function() processing, {
  String? dioErrorText,
  String? responseParseErrorText,
  // String? successFalseErrorText,
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
      // successFalseErrorText: successFalseErrorText,
      otherErrorText: otherErrorText,
    );

    currentAttempt += 1;

    if (currentAttempt == maxAttempts || ex == null) {
      // Мы выходим после достижения последней попытки,
      // либо если у нас запрос отработал без ошибок
      break;
    }

    await Future<void>.delayed(attemptsDelay(currentAttempt));
  }

  await after?.call();

  if (ex != null) {
    log(
      '${ex.title}: ${ex.subtitle}',
      stackTrace: ex.stackTrace,
    );
    await onError?.call(ex);
  } else {
    return await onSuccess?.call(data);
  }
}

Duration Function(int attempt) _defaultAttemptsDelay =
    (attempt) => const Duration(
          milliseconds: 500,
        );

/// Функция, которая производит один вызов [processing]
///
/// Используется в [execute], чтобы выполнить некоторое заданное количество раз.
Future<(T?, CustomException?)> _process<T>(
  Future<T> Function() processing, {
  String? dioErrorText,
  String? responseParseErrorText,
  // String? successFalseErrorText,
  String? otherErrorText,
}) async {
  CustomException? ex;
  T? data;

  try {
    data = await processing();
  } on DioException catch (e) {
    if (e.type == DioExceptionType.unknown) {
      ex = CustomException(
        title: 'Соединение отсутствует',
        subtitle:
            'Как только соединение восстановится, вы снова сможете пользоваться приложением',
        stackTrace: e.stackTrace,
      );
    } else {
      ex = CustomException(
        title: dioErrorText ?? 'Ошибка при отправке запроса',
        subtitle: e.message,
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
    if (e.toString() == 'Ошибка доступа') {
      // UserSingleton.clearUserData();
      // AuthorizationSingleton.setAuthorization(false);
    }
    ex = CustomException(
      title: e.toString(),
      stackTrace: e.stackTrace,
    );
  } catch (e) {
    ex = CustomException(
      title: otherErrorText ?? 'Непредвиденная ошибка',
      subtitle: e.toString(),
      stackTrace: StackTrace.current,
    );
  }

  return (data, ex);
}
