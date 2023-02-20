class SuccessFalse implements Exception {
  SuccessFalse([String? message]) : _message = message;

  late final String? _message;

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
