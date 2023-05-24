class SuccessFalse implements Exception {
  final StackTrace? stackTrace;

  late final String? _message;

  SuccessFalse([String? message, StackTrace? stackTrace])
      : _message = message,
        stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => _message ?? 'SuccessFalse';
}
