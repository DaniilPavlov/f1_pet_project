import 'dart:async';
import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Checks if response was already cached.
///
/// If yes, returns cached response.

Future<BaseResponseModel?> checkCache(
  Future<BaseResponseModel> Function() checkFunc,
) async {
  BaseResponseModel? rawData;
  try {
    rawData = await checkFunc();
  } on DioException catch (e) {
    if (e.response?.data != null) {
      rawData =
          BaseResponseModel.fromJson(e.response!.data as Map<String, dynamic>);

      // TODO(pavlov): idk do or not to do permanent showing

      unawaited(
        Fluttertoast.showToast(
          msg: 'Соединение отсутствует',
          backgroundColor: AppTheme.red,
        ),
      );
    } else {
      Error.throwWithStackTrace(
        e,
        StackTrace.current,
      );
    }
  } catch (e) {
    Error.throwWithStackTrace(
      e,
      StackTrace.current,
    );
  }

  return rawData;
}
