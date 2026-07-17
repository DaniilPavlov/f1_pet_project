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
    if (e.response?.data != null) {
      rawData = BaseResponseModel.fromJson(e.response!.data as Map<String, dynamic>);
      // TODO(think): decide do or not to do permanent showing
      unawaited(Fluttertoast.showToast(msg: 'Соединение отсутствует', backgroundColor: AppTheme.red));
    } else {
      Error.throwWithStackTrace(e, StackTrace.current);
    }
  } catch (e) {
    Error.throwWithStackTrace(e, StackTrace.current);
  }

  return rawData;
}
