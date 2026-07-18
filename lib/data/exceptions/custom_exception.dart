/// Пользовательское исключение с заголовком и описанием ошибки.
class CustomException implements Exception {
  const CustomException({required this.title, this.subtitle, this.parentException, this.stackTrace});
  final String title;

  final String? subtitle;

  final Exception? parentException;

  final StackTrace? stackTrace;
}
