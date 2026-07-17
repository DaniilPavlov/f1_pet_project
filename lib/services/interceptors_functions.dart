import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Загружает данные из кэша при сетевой ошибке и показывает toast.
Future<BaseResponseModel?> checkCache(Future<BaseResponseModel> Function() checkFunc) async {
  BaseResponseModel? rawData;
  try {
    rawData = await checkFunc();
  } on DioException catch (e) {
    final data = e.response?.data;
    // 429 и прочие ответы часто приходят строкой, а не JSON
    if (data is Map<String, dynamic>) {
      rawData = BaseResponseModel.fromJson(data);
      unawaited(Fluttertoast.showToast(msg: 'Соединение отсутствует', backgroundColor: AppTheme.red));
    } else {
      Error.throwWithStackTrace(e, StackTrace.current);
    }
  } catch (e) {
    Error.throwWithStackTrace(e, StackTrace.current);
  }

  return rawData;
}
