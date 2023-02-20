class CustomException implements Exception {
  const CustomException({
    required this.title,
    this.subtitle,
    this.ex,
  });

  final String title;
  final String? subtitle;
  final Exception? ex;
}
