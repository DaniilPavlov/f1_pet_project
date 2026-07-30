import 'package:f1_pet_project/core/results/season_rewind/models/season_rewind_bar_entry.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';

/// Преобразует standings Jolpica в записи racing-chart.
abstract final class SeasonRewindBarMapper {
  static List<SeasonRewindBarEntry> fromDrivers(List<DriverStandingsModel> standings) {
    final sorted = [...standings]..sort((a, b) {
      final byPoints = (double.tryParse(b.points) ?? 0).compareTo(double.tryParse(a.points) ?? 0);
      if (byPoints != 0) {
        return byPoints;
      }
      return (int.tryParse(a.position) ?? 99).compareTo(int.tryParse(b.position) ?? 99);
    });

    return [
      for (var i = 0; i < sorted.length; i++)
        SeasonRewindBarEntry(
          id: sorted[i].driver.driverId,
          constructorId: sorted[i].constructors.isNotEmpty
              ? sorted[i].constructors.first.constructorId
              : sorted[i].driver.driverId,
          label: sorted[i].driver.familyName,
          tag: sorted[i].driver.code ?? '',
          points: double.tryParse(sorted[i].points) ?? 0,
          rank: i.toDouble(),
        ),
    ];
  }

  static List<SeasonRewindBarEntry> fromConstructors(List<ConstructorStandingsModel> standings) {
    final sorted = [...standings]..sort((a, b) {
      final byPoints = (double.tryParse(b.points) ?? 0).compareTo(double.tryParse(a.points) ?? 0);
      if (byPoints != 0) {
        return byPoints;
      }
      return (int.tryParse(a.position) ?? 99).compareTo(int.tryParse(b.position) ?? 99);
    });

    return [
      for (var i = 0; i < sorted.length; i++)
        SeasonRewindBarEntry(
          id: sorted[i].constructor.constructorId,
          constructorId: sorted[i].constructor.constructorId,
          label: sorted[i].constructor.name,
          tag: '',
          points: double.tryParse(sorted[i].points) ?? 0,
          rank: i.toDouble(),
        ),
    ];
  }
}
