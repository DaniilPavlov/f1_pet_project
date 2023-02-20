// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> ULaunchUrl({
    required String rawUrl,
    bool isPhone = false,
    bool externalApplication = false,
    void Function(CustomException ex)? onError,
  }) async {
    // final newRawUrl =
    //     rawUrl.startsWith('/') ? rawUrl.replaceFirst('/', '') : rawUrl;

    // final url = Uri.parse(
    //   '${isPhone ? 'tel:' : !rawUrl.contains('http') ? StaticData.url : ''}$newRawUrl',
    // );

    // final finalUrl = rawUrl.startsWith('mailto')
    //     ? Uri(
    //         scheme: 'mailto',
    //         path: rawUrl.replaceFirst('mailto:', ''),
    //       )
    //     : url;

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
}
