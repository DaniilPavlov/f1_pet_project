class ResponseParseException implements Exception {
  final StackTrace? stackTrace;

  late final String? _message;

  ResponseParseException([this._message, StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
