import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:url_launcher/url_launcher.dart';

/// Утилиты общего назначения: ссылки и форматирование времени.
class Utils {
  /// Открывает URL во внешнем или системном браузере.
  static Future<bool> openUrl({
    required String rawUrl,
    bool externalApplication = false,
    void Function(CustomException ex)? onError,
  }) async {
    final finalUrl = Uri.parse(rawUrl);

    if (await canLaunchUrl(finalUrl)) {
      return launchUrl(
        finalUrl,
        mode: externalApplication ? LaunchMode.externalApplication : LaunchMode.platformDefault,
      );
    } else {
      onError?.call(CustomException(title: 'Could not open link $rawUrl'));

      return false;
    }
  }

  /// Форматирует время в строку вида «ЧЧ:ММ».
  static String formatHourMinute(DateTime date) {
    final hour = date.hour >= 10 ? date.hour : '0${date.hour}';
    final minute = date.minute >= 10 ? date.minute : '0${date.minute}';
    return '$hour:$minute';
  }
}
