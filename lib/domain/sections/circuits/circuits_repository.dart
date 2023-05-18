import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/providers/circuits/circuits_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircuitsRepository {
  Future<List<CircuitModel>?> loadCircuits(
    AutoDisposeFutureProviderRef<List<CircuitModel>?> ref,
  ) async {
    List<CircuitModel>? result;
    await execute<CircuitsModel>(
      () async {
        final rawData = await CircuitsLoader.loadData();

        return CircuitsModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      onSuccess: (data) {
        result = data!.CircuitTable.Circuits;
        ref.read(circuitsErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(circuitsErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }
}
