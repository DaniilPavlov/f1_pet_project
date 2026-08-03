import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Если Dio вернул ошибку с JSON-телом — парсит его как успешный ответ.
///
/// Используется для опциональных секций уикенда (sprint / quali / pitstops),
/// где 404 с `MRData` — нормальный «пустой» ответ. Toast только при rate-limit.
Future<BaseResponseModel?> withErrorBodyFallback(Future<BaseResponseModel> Function() request) async {
  try {
    return await request();
  } on DioException catch (e) {
    final data = e.response?.data;
    // 429 и прочие ответы часто приходят строкой, а не JSON
    if (data is Map<String, dynamic>) {
      final status = e.response?.statusCode;
      if (status == 429) {
        unawaited(Fluttertoast.showToast(msg: ErrorCopy.tooManyRequests, backgroundColor: AppTheme.red));
      }
      return BaseResponseModel.fromJson(data);
    }
    Error.throwWithStackTrace(e, StackTrace.current);
  } catch (e) {
    Error.throwWithStackTrace(e, StackTrace.current);
  }
}
