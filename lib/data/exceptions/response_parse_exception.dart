class ResponseParseException implements Exception {
  late final String? _message;
  ResponseParseException([this._message]);

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
