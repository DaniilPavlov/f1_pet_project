import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';

/// Агрегированная карьера пилота (из totals Jolpica + список команд).
class DriverCareerStats {
  const DriverCareerStats({
    required this.races,
    required this.wins,
    required this.podiums,
    required this.poles,
    required this.constructors,
  });

  final int races;
  final int wins;
  final int podiums;
  final int poles;
  final List<ConstructorModel> constructors;
}
