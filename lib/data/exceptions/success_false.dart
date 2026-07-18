/// Исключение, когда сервер вернул неуспешный статус (success: false).
class SuccessFalse implements Exception {
  SuccessFalse([String? message, StackTrace? stackTrace])
    : _message = message,
      stackTrace = stackTrace ?? StackTrace.current;
  final StackTrace? stackTrace;

  late final String? _message;

  /// Возвращает сообщение об ошибке от сервера.
  @override
  String toString() => _message ?? 'SuccessFalse';
}
