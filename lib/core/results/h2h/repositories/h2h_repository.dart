import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';

/// H2H-метрики пилотов и конструкторов.
class H2hRepository {
  const H2hRepository();

  Future<H2hStats> driverStats({required String driverId, String? season}) =>
      _loadTotals(entityPath: 'drivers/$driverId', season: season);

  Future<H2hStats> constructorStats({required String constructorId, String? season}) =>
      _loadTotals(entityPath: 'constructors/$constructorId', season: season);

  Future<H2hStats> _loadTotals({required String entityPath, String? season}) async {
    final prefix = _prefix(season);
    final responses = await CareerApiHelper.getThrottled([
      '$prefix$entityPath/results',
      '$prefix$entityPath/results/1',
      '$prefix$entityPath/results/2',
      '$prefix$entityPath/results/3',
      '$prefix$entityPath/qualifying/1',
    ], limit: 1);

    final wins = CareerApiHelper.totalOf(responses[1]);
    final second = CareerApiHelper.totalOf(responses[2]);
    final third = CareerApiHelper.totalOf(responses[3]);

    return H2hStats(
      races: CareerApiHelper.totalOf(responses[0]),
      wins: wins,
      podiums: wins + second + third,
      poles: CareerApiHelper.totalOf(responses[4]),
    );
  }

  String _prefix(String? season) {
    if (season == null || season.trim().isEmpty) {
      return '';
    }
    return '${season.trim()}/';
  }
}
