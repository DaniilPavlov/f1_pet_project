import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:flutter/material.dart';

/// Web-заглушка: Yandex MapKit на web недоступен.
class CircuitsMap extends StatelessWidget {
  const CircuitsMap({required this.circuits, super.key});

  final List<CircuitModel> circuits;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
