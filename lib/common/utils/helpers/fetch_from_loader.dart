import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';

/// Загружает и парсит данные через лоадер с опциональным override и кешем.
Future<T> fetchFromLoader<T>({
  required Future<T> Function()? override,
  required Future<BaseResponseModel> Function() load,
  required T Function(Map<String, dynamic> json) parse,
  Future<BaseResponseModel?> Function(Future<BaseResponseModel> Function())? withCache,
}) async {
  if (override != null) {
    return override();
  }

  Future<BaseResponseModel> request() => load();
  final rawData = withCache != null ? await withCache(request) : await request();
  return parse(rawData!.mrData as Map<String, dynamic>);
}
