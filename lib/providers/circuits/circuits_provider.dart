import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final circuitsDataProvider =
    FutureProvider.autoDispose<List<CircuitModel>?>((ref) async {
  final circuits = await ref.read(circuitsProvider.future);

  return circuits;
});

final circuitsProvider = FutureProvider.autoDispose<List<CircuitModel>?>((ref) {
  final circuitsRepository = ref.read(circuitsRepositoryProvider);

  return circuitsRepository.loadCircuits(ref);
});

final circuitsErrorProvider = StateProvider<CustomException?>((ref) => null);

final circuitsRepositoryProvider = Provider<CircuitsRepository>((ref) {
  return CircuitsRepository();
});
