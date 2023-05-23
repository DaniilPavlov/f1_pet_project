import 'dart:async';
import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO(info): функция проверяет есть ли у нас сохраненный response
// если да, возвращаем его вместо ответа

Future<BaseResponseModel?> checkCache(
  Future<BaseResponseModel> Function() checkFunc,
) async {
  BaseResponseModel? rawData;
  try {
    rawData = await checkFunc();
  } on DioError catch (e) {
    if (e.response?.data != null) {
      rawData =
          BaseResponseModel.fromJson(e.response!.data as Map<String, dynamic>);

      /// Showing info that connection is interrapted.
      unawaited(Fluttertoast.showToast(
        msg: 'Соединение отсутствует',
        backgroundColor: AppTheme.red,
      ));
    } else {
      Error.throwWithStackTrace(
        e,
        StackTrace.current,
      );
    }
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    Error.throwWithStackTrace(
      e,
      StackTrace.current,
    );
  }

  return rawData;
}