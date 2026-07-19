import 'package:f1_pet_project/common/career/loaders/career_loader_helper.dart';
import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';

/// Загрузка карьерной статистики пилота через Jolpica/Ergast.
abstract class DriverCareerLoader {
  /// Totals + все команды. [current] — из standings, без отдельного API.
  static Future<CareerStats<ConstructorModel>> loadData({
    required String driverId,
    List<ConstructorModel> current = const [],
  }) async {
    final responses = await CareerLoaderHelper.getThrottled([
      'drivers/$driverId/results',
      'drivers/$driverId/results/1',
      'drivers/$driverId/results/2',
      'drivers/$driverId/results/3',
      'drivers/$driverId/qualifying/1',
      'drivers/$driverId/constructors',
    ]);

    final races = CareerLoaderHelper.totalOf(responses[0]);
    final wins = CareerLoaderHelper.totalOf(responses[1]);
    final second = CareerLoaderHelper.totalOf(responses[2]);
    final third = CareerLoaderHelper.totalOf(responses[3]);
    final poles = CareerLoaderHelper.totalOf(responses[4]);
    final related = CareerLoaderHelper.parseTableEntities(
      response: responses[5],
      tableKey: 'ConstructorTable',
      listKey: 'Constructors',
      fromJson: ConstructorModel.fromJson,
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
