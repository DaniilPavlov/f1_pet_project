class ResponseParseException implements Exception {
  ResponseParseException([this._message, StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.current;
  final StackTrace? stackTrace;

  late final String? _message;

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
