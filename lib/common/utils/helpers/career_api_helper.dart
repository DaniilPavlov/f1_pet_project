import 'package:f1_pet_project/common/models/career/career_race_result.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Хелперы карьерных запросов к Jolpica (throttle ≤4 req/s, пагинация).
abstract class CareerApiHelper {
  static const minGap = Duration(milliseconds: 500);

  /// Jolpica/Ergast обычно режут [limit] до 100.
  static const maxPageSize = 100;

  /// Последовательные GET с интервалом ≥[minGap] между стартами.
  /// [limits] — лимит на каждый path; иначе везде [limit].
  static Future<List<BaseResponseModel>> getThrottled(
    List<String> paths, {
    int limit = 100,
    List<int>? limits,
  }) async {
    assert(limits == null || limits.length == paths.length, 'limits must match paths');
    final responses = <BaseResponseModel>[];
    DateTime? lastStart;

    for (var i = 0; i < paths.length; i++) {
      if (lastStart != null) {
        final elapsed = DateTime.now().difference(lastStart);
        if (elapsed < minGap) {
          await Future<void>.delayed(minGap - elapsed);
        }
      }
      lastStart = DateTime.now();
      final pathLimit = limits?[i] ?? limit;
      responses.add(await ApiLoader.get(paths[i], limit: pathLimit));
    }

    return responses;
  }

  /// Все страницы endpoint’а (limit ≤ [maxPageSize]), с throttle между запросами.
  static Future<List<BaseResponseModel>> fetchAllPages(
    String path, {
    int pageSize = maxPageSize,
  }) async {
    final size = pageSize.clamp(1, maxPageSize);
    final pages = <BaseResponseModel>[];
    var offset = 0;
    DateTime? lastStart;

    while (true) {
      if (lastStart != null) {
        final elapsed = DateTime.now().difference(lastStart);
        if (elapsed < minGap) {
          await Future<void>.delayed(minGap - elapsed);
        }
      }
      lastStart = DateTime.now();
      final response = await ApiLoader.get(path, limit: size, offset: offset);
      pages.add(response);

      final pageRaces = _raceCount(response);
      if (pageRaces == 0) {
        break;
      }

      offset += size;
      final total = totalOf(response);
      if (total > 0 && offset >= total) {
        break;
      }
      // Защита от бесконечного цикла, если total врёт.
      if (pageRaces < size && total == 0) {
        break;
      }
    }

    return pages;
  }

  /// Значение `MRData.total` (полное число записей, не обрезанное limit’ом страницы).
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

  /// Уникальные гонки (`season`+`round`) по всем страницам.
  static int uniqueRaceCountAcross(List<BaseResponseModel> pages) {
    final keys = <String>{};
    for (final page in pages) {
      try {
        final schedule = ScheduleModel.fromJson(Map<String, dynamic>.from(page.mrData as Map));
        for (final race in schedule.raceTable.races) {
          keys.add(_raceKey(race.season, race.round));
        }
      } on Object {
        // skip broken page
      }
    }
    return keys.length;
  }

  /// Оставляет одну запись на гонку с лучшей (меньшей) позицией.
  static List<CareerRaceResult> dedupeByBestPosition(List<CareerRaceResult> races) {
    final best = <String, CareerRaceResult>{};
    for (final race in races) {
      final key = _raceKey(race.season, race.round);
      final prev = best[key];
      if (prev == null || race.position < prev.position) {
        best[key] = race;
      }
    }
    return best.values.toList(growable: false);
  }

  static String _raceKey(String season, String round) => '$season-$round';

  static int _raceCount(BaseResponseModel response) {
    try {
      final schedule = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
      return schedule.raceTable.races.length;
    } on Object {
      return 0;
    }
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
