import 'package:f1_pet_project/core/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Статусы финишей сезона (`{year}/status`).
abstract class SeasonStatusLoader {
  static Future<List<FinishStatusItem>> loadData({required String year}) async {
    final response = await ApiLoader.get('$year/status');
    final mrData = response.mrData;
    if (mrData is! Map) {
      return const [];
    }
    final table = mrData['StatusTable'];
    if (table is! Map) {
      return const [];
    }
    final raw = table['Status'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((e) => FinishStatusItem.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }
}
