import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/foundation.dart';

/// Аргументы семейства провайдера экрана пилота.
@immutable
class DriverPageArgs {
  const DriverPageArgs({
    required this.driver,
    this.currentConstructors = const [],
  });

  final DriverModel driver;
  final List<ConstructorModel> currentConstructors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverPageArgs &&
          runtimeType == other.runtimeType &&
          driver.driverId == other.driver.driverId;

  @override
  int get hashCode => driver.driverId.hashCode;
}
