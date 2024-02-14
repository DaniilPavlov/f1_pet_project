import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> openUrl({
    required String rawUrl,
    bool externalApplication = false,
    void Function(CustomException ex)? onError,
  }) async {
    final finalUrl = Uri.parse(rawUrl);

    if (await canLaunchUrl(finalUrl)) {
      return launchUrl(
        finalUrl,
        mode: externalApplication
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    } else {
      onError?.call(
        CustomException(title: 'Не удалось перейти по ссылке $rawUrl'),
      );

      return false;
    }
  }

  static String getMonthNameByNumber({required int month, bool parent = true}) {
    switch (month) {
      case 2:
        return parent ? 'февраля' : 'февраль';
      case 3:
        return parent ? 'марта' : 'март';
      case 4:
        return parent ? 'апреля' : 'апрель';
      case 5:
        return parent ? 'мая' : 'май';
      case 6:
        return parent ? 'июня' : 'июнь';
      case 7:
        return parent ? 'июля' : 'июль';
      case 8:
        return parent ? 'августа' : 'август';
      case 9:
        return parent ? 'сентября' : 'сентябрь';
      case 10:
        return parent ? 'октября' : 'октябрь';
      case 11:
        return parent ? 'ноября' : 'ноябрь';
      case 12:
        return parent ? 'декабря' : 'декабрь';

      case 1:
      default:
        return parent ? 'января' : 'январь';
    }
  }

  static String formatHourMinute(DateTime date) {
    final hour = date.hour >= 10 ? date.hour : '0${date.hour}';
    final minute = date.minute >= 10 ? date.minute : '0${date.minute}';
    return '$hour:$minute';
  }
}
