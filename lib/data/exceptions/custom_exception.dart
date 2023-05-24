class CustomException implements Exception {
  final String title;

  final String? subtitle;

  final Exception? parentException;

  final StackTrace? stackTrace;

  const CustomException({
    required this.title,
    this.subtitle,
    this.parentException,
    this.stackTrace,
  });
}
