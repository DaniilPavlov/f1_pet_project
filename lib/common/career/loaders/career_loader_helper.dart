import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Общие хелперы загрузки карьерной статистики (Jolpica ≤4 req/s).
abstract class CareerLoaderHelper {
  static const minGap = Duration(milliseconds: 500);

  /// Последовательные GET с интервалом ≥[minGap] между стартами.
  static Future<List<BaseResponseModel>> getThrottled(List<String> paths) async {
    final responses = <BaseResponseModel>[];
    DateTime? lastStart;

    for (final path in paths) {
      if (lastStart != null) {
        final elapsed = DateTime.now().difference(lastStart);
        if (elapsed < minGap) {
          await Future<void>.delayed(minGap - elapsed);
        }
      }
      lastStart = DateTime.now();
      responses.add(await ApiLoader.get(path));
    }

    return responses;
  }

  static int totalOf(BaseResponseModel response) {
    final mrData = response.mrData;
    if (mrData is! Map) {
      return 0;
    }
    final total = mrData['total'];
    if (total is int) {
      return total;
    }
    return int.tryParse(total?.toString() ?? '') ?? 0;
  }

  static List<T> parseTableEntities<T>({
    required BaseResponseModel response,
    required String tableKey,
    required String listKey,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    final mrData = response.mrData;
    if (mrData is! Map) {
      return const [];
    }
    final table = mrData[tableKey];
    if (table is! Map) {
      return const [];
    }
    final raw = table[listKey];
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);
  }
}
