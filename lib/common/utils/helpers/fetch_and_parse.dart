import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';

/// Загружает Jolpica `MRData` и парсит в модель; опционально оборачивает [load]
/// (например `withErrorBodyFallback`).
///
/// GoF Behavioral Strategy — способ получения данных выбирается на вызове:
/// прямой `load` или обёртка `wrap` — взаимозаменяемые стратегии.
Future<T> fetchAndParse<T>({
  required Future<BaseResponseModel> Function() load,
  required T Function(Map<String, dynamic> json) parse,
  Future<BaseResponseModel?> Function(Future<BaseResponseModel> Function())? wrap,
}) async {
  final rawData = wrap != null ? await wrap(load) : await load();
  return parse(rawData!.mrData as Map<String, dynamic>);
}
