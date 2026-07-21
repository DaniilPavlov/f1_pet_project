import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';

/// Финиш в конкретной гонке (победа / подиум / поул).
class CareerRaceResult {
  const CareerRaceResult({
    required this.season,
    required this.round,
    required this.raceName,
    required this.position,
    required this.constructor,
    required this.circuit,
    this.driver,
  });

  final String season;
  final String round;
  final String raceName;
  final int position;
  final ConstructorModel constructor;
  final CircuitModel circuit;

  /// Для списков конструктора — пилот, занявший позицию.
  final DriverModel? driver;

  /// Подзаголовок строки: пилот (если есть) или конструктор.
  String get entityName {
    final d = driver;
    if (d != null) {
      return '${d.givenName} ${d.familyName}'.trim();
    }
    return constructor.name;
  }
}
