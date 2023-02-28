class CustomException implements Exception {
  final String title;
  final String? subtitle;
  final Exception? ex;
  const CustomException({
    required this.title,
    this.subtitle,
    this.ex,
  });
}
