// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/exceptions/success_false.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> ULaunchUrl({
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

  static CustomException fetchError(Object e) {
    CustomException? ex;
    if (e.runtimeType is DioError) {
      if ((e as DioError).type == DioErrorType.unknown) {
        ex = const CustomException(
          title: 'Соединение отсутствует',
          subtitle:
              'Как только соединение восстановится, вы снова сможете пользоваться приложением',
        );
      } else {
        ex = CustomException(
          // title: dioErrorText ?? 'Ошибка при отправке запроса',
          title: 'Ошибка при отправке запроса',
          subtitle: e.message,
        );
      }
    } else if (e.runtimeType is ResponseParseException) {
      ex = CustomException(
        // title: responseParseErrorText ?? 'Ошибка при обработке ответа от сервера',
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } else if (e.runtimeType is SuccessFalse) {
      ex = CustomException(
        title: e.toString(),
      );
      // } on AccessError catch (e) {
      //   ex = CustomException(
      //     title: successFalseErrorText ?? 'Ошибка',
      //     subtitle: e.toString(),
      //   );
      //   onAccessError?.call(ex);
      // ignore: avoid_catches_without_on_clauses
    } else {
      ex = CustomException(
        // title: otherErrorText ?? 'Непредвиденная ошибка',
        title: 'Непредвиденная ошибка',
        subtitle: e.toString(),
      );
    }

    return ex;
  }
}
