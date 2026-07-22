import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Если Dio вернул ошибку с JSON-телом — парсит его как успешный ответ и показывает toast.
/// Иначе пробрасывает исключение. Это не in-memory кэш ([CacheInterceptor]).
Future<BaseResponseModel?> withErrorBodyFallback(Future<BaseResponseModel> Function() request) async {
  try {
    return await request();
  } on DioException catch (e) {
    final data = e.response?.data;
    // 429 и прочие ответы часто приходят строкой, а не JSON
    if (data is Map<String, dynamic>) {
      unawaited(Fluttertoast.showToast(msg: ErrorCopy.noConnection, backgroundColor: AppTheme.red));
      return BaseResponseModel.fromJson(data);
    }
    Error.throwWithStackTrace(e, StackTrace.current);
  } catch (e) {
    Error.throwWithStackTrace(e, StackTrace.current);
  }
}
