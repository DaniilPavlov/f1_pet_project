import 'dart:async';

import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/executor.dart';

/// Выполняет асинхронную загрузку с обновлением [AsyncValue] через MobX.
///
/// По умолчанию до 3 попыток: Jolpica иногда рвёт соединение
/// (`Connection reset by peer`) при параллельных запросах на старте.
Future<void> runAsyncLoad<T, R>({
  required Future<T> Function() fetch,
  required AsyncValue<R> Function() getField,
  required void Function(AsyncValue<R> value) setField,
  required FutureOr<void> Function(T? data) onSuccess,
  int maxAttempts = 3,
}) {
  return execute<T>(
    fetch,
    maxAttempts: maxAttempts,
    before: () => setField(getField().toLoading()),
    onSuccess: onSuccess,
    onError: (error) => setField(getField().toErrorFrom(error)),
  );
}

/// Возвращает первую ошибку из набора [AsyncValue].
CustomException? firstException(Iterable<AsyncValue<dynamic>> values) {
  for (final value in values) {
    final exception = value.exception;
    if (exception != null) {
      return exception;
    }
  }
  return null;
}
