class SuccessFalse implements Exception {

  SuccessFalse([String? message, StackTrace? stackTrace])
      : _message = message,
        stackTrace = stackTrace ?? StackTrace.current;
  final StackTrace? stackTrace;

  late final String? _message;

  @override
  String toString() => _message ?? 'SuccessFalse';
}
