// ignore_for_file: avoid_annotating_with_dynamic

import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/domain/services/request_handler.dart';

abstract class RequestHelper {
  static final _rh = RequestHandler();

  static Future<BaseResponseModel> get(
    String path,
  ) async {
    final res = await _rh.get<dynamic>(path);

    return BaseResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  // static Future<T> getSimpleObject<T>(
  //   String path,
  // ) async {
  //   final response = await _rh.get(path);

  //   return response.data as T;
  // }

  // static Future<List<T>> getListOfSimpleObjects<T>(
  //   String path,
  // ) async {
  //   final response = await _rh.get(path);

  //   final list =
  //       (response.data as List<dynamic>).map((dynamic e) => e as T).toList();

  //   return list;
  // }

  // static Future<T> getObject<T>(
  //   String path,
  //   T Function(Map<String, dynamic>) fromJson,
  // ) async {
  //   final response = await _rh.get(path);

  //   final obj = fromJson(response.data as Map<String, dynamic>);

  //   return obj;
  // }

  // static Future<List<T>> getListOfObjects<T>(
  //   String path,
  //   T Function(Map<String, dynamic>) fromJson,
  // ) async {
  //   final response = await _rh.get(path);

  //   final list = (response.data as List<dynamic>)
  //       .map((dynamic e) => fromJson(e as Map<String, dynamic>))
  //       .toList();

  //   return list;
  // }
}
