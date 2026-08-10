import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/foundation.dart';

/// Аргументы семейства провайдера экрана конструктора.
@immutable
class ConstructorPageArgs {
  const ConstructorPageArgs({
    required this.constructor,
    this.currentDrivers = const [],
  });

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConstructorPageArgs &&
          runtimeType == other.runtimeType &&
          constructor.constructorId == other.constructor.constructorId;

  @override
  int get hashCode => constructor.constructorId.hashCode;
}
