import 'package:f1_pet_project/core/driver/models/driver_career_stats.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузка карьерной статистики пилота через Jolpica/Ergast.
abstract class DriverCareerLoader {
  /// Jolpica: ≤4 req/s — стартуем запросы с паузой, не пачкой. Максимум можно 4 запроса в секунду.
  static const _minGap = Duration(milliseconds: 500);

  /// Собирает totals по results/qualifying и список команд.
  static Future<DriverCareerStats> loadData({required String driverId}) async {
    final responses = await _getThrottled([
      'drivers/$driverId/results',
      'drivers/$driverId/results/1',
      'drivers/$driverId/results/2',
      'drivers/$driverId/results/3',
      'drivers/$driverId/qualifying/1',
      'drivers/$driverId/constructors',
    ]);

    final races = _totalOf(responses[0]);
    final wins = _totalOf(responses[1]);
    final second = _totalOf(responses[2]);
    final third = _totalOf(responses[3]);
    final poles = _totalOf(responses[4]);
    final constructors = _parseConstructors(responses[5]);

    return DriverCareerStats(
      races: races,
      wins: wins,
      podiums: wins + second + third,
      poles: poles,
      constructors: constructors,
    );
  }

  /// Последовательные GET с интервалом ≥[_minGap] между стартами.
  static Future<List<BaseResponseModel>> _getThrottled(List<String> paths) async {
    final responses = <BaseResponseModel>[];
    DateTime? lastStart;

    for (final path in paths) {
      if (lastStart != null) {
        final elapsed = DateTime.now().difference(lastStart);
        if (elapsed < _minGap) {
          await Future<void>.delayed(_minGap - elapsed);
        }
      }
      lastStart = DateTime.now();
      responses.add(await ApiLoader.get(path));
    }

    return responses;
  }

  static int _totalOf(BaseResponseModel response) {
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

  static List<ConstructorModel> _parseConstructors(BaseResponseModel response) {
    final mrData = response.mrData;
    if (mrData is! Map) {
      return const [];
    }
    final table = mrData['ConstructorTable'];
    if (table is! Map) {
      return const [];
    }
    final raw = table['Constructors'];
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ConstructorModel.fromJson)
        .toList(growable: false);
  }
}
