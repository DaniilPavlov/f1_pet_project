import 'package:f1_pet_project/common/career/loaders/career_loader_helper.dart';
import 'package:f1_pet_project/core/h2h/models/h2h_stats.dart';

/// Загрузка метрик для H2H (карьера или сезон).
abstract class H2hStatsLoader {
  /// Пилот: totals через `MRData.total` с [limit] 1.
  static Future<H2hStats> load({required String driverId, String? season}) {
    return _loadTotals(entityPath: 'drivers/$driverId', season: season);
  }

  /// Конструктор: totals из `MRData.total` (не длина первой страницы ≤100).
  static Future<H2hStats> loadForConstructor({required String constructorId, String? season}) {
    return _loadTotals(entityPath: 'constructors/$constructorId', season: season);
  }

  static Future<H2hStats> _loadTotals({required String entityPath, String? season}) async {
    final prefix = _prefix(season);
    final responses = await CareerLoaderHelper.getThrottled([
      '$prefix$entityPath/results',
      '$prefix$entityPath/results/1',
      '$prefix$entityPath/results/2',
      '$prefix$entityPath/results/3',
      '$prefix$entityPath/qualifying/1',
    ], limit: 1);

    final wins = CareerLoaderHelper.totalOf(responses[1]);
    final second = CareerLoaderHelper.totalOf(responses[2]);
    final third = CareerLoaderHelper.totalOf(responses[3]);

    return H2hStats(
      races: CareerLoaderHelper.totalOf(responses[0]),
      wins: wins,
      podiums: wins + second + third,
      poles: CareerLoaderHelper.totalOf(responses[4]),
    );
  }

  static String _prefix(String? season) {
    if (season == null || season.trim().isEmpty) {
      return '';
    }
    return '${season.trim()}/';
  }
}
