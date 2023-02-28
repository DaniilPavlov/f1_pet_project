import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/exceptions/success_false.dart';

Future<void> execute<T>(
  Future<T> Function() processing, {
  String? dioErrorText,
  String? responseParseErrorText,
  String? successFalseErrorText,
  String? otherErrorText,
  FutureOr<void> Function()? before,
  FutureOr<void> Function()? after,
  FutureOr<void> Function(T? data)? onSuccess,
  FutureOr<void> Function(CustomException e)? onError,
  // FutureOr<void> Function(CustomException e)? onAccessError,
}) async {
  CustomException? ex;
  T? data;

  await before?.call();

  try {
    data = await processing();
  } on DioError catch (e) {
    if (e.type == DioErrorType.other) {
      ex = const CustomException(
        title: 'Соединение отсутствует',
        subtitle:
            'Как только соединение восстановится, вы снова сможете пользоваться приложением',
      );
    } else {
      ex = CustomException(
        title: dioErrorText ?? 'Ошибка при отправке запроса',
        subtitle: e.message,
      );
    }
  } on ResponseParseException catch (e) {
    ex = CustomException(
      title: responseParseErrorText ?? 'Ошибка при обработке ответа от сервера',
      subtitle: e.toString(),
    );
  } on SuccessFalse catch (e) {
    ex = CustomException(
      title: e.toString(),
    );
    // } on AccessError catch (e) {
    //   ex = CustomException(
    //     title: successFalseErrorText ?? 'Ошибка',
    //     subtitle: e.toString(),
    //   );
    //   onAccessError?.call(ex);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    ex = CustomException(
      title: otherErrorText ?? 'Непредвиденная ошибка',
      subtitle: e.toString(),
    );

    // log(
    //   'ExecutorError: Непредвиденная ошибка: ${e.toString()}',
    //   stackTrace: StackTrace.current,
    // );
  }

  await after?.call();

  if (ex != null) {
    log(
      'ExecutorError: ${ex.title} : ${ex.subtitle}',
      stackTrace: StackTrace.current,
    );
    await onError?.call(ex);
  } else {
    return await onSuccess?.call(data);
  }
}
