class SuccessFalse implements Exception {
  late final String? _message;
  SuccessFalse([String? message]) : _message = message;

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
