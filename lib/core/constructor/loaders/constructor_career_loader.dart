import 'package:f1_pet_project/common/career/loaders/career_loader_helper.dart';
import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';

/// Загрузка карьерной статистики конструктора через Jolpica/Ergast.
abstract class ConstructorCareerLoader {
  /// Totals + все пилоты. [current] — из standings, без отдельного API.
  static Future<CareerStats<DriverModel>> loadData({
    required String constructorId,
    List<DriverModel> current = const [],
  }) async {
    final responses = await CareerLoaderHelper.getThrottled([
      'constructors/$constructorId/results',
      'constructors/$constructorId/results/1',
      'constructors/$constructorId/results/2',
      'constructors/$constructorId/results/3',
      'constructors/$constructorId/qualifying/1',
      'constructors/$constructorId/drivers',
    ]);

    final races = CareerLoaderHelper.totalOf(responses[0]);
    final wins = CareerLoaderHelper.totalOf(responses[1]);
    final second = CareerLoaderHelper.totalOf(responses[2]);
    final third = CareerLoaderHelper.totalOf(responses[3]);
    final poles = CareerLoaderHelper.totalOf(responses[4]);
    final related = CareerLoaderHelper.parseTableEntities(
      response: responses[5],
      tableKey: 'DriverTable',
      listKey: 'Drivers',
      fromJson: DriverModel.fromJson,
    );

    return CareerStats(
      races: races,
      wins: wins,
      podiums: wins + second + third,
      poles: poles,
      current: current,
      related: related,
    );
  }
}
