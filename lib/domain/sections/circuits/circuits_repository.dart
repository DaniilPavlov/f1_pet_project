import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';

// TODO(pavlov): обрабатывать ошибки неудобно и пока не ясно как
class CircuitsRepository {
  Future<List<CircuitModel>?> loadCircuits() async {
    List<CircuitModel>? result;
    await execute<CircuitsModel>(
      () async {
        final rawData = await CircuitsLoader.loadData();

        return CircuitsModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      // before: _circuits.loading,
      onSuccess: (data) {
        result = data!.CircuitTable.Circuits;
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _circuits.error(value);
      // },
    );
    return result;
  }
}
