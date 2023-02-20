class ResponseParseException implements Exception {
  ResponseParseException([this._message]);

  late final String? _message;

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
