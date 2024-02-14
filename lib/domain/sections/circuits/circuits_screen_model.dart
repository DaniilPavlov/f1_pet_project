import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_loader.dart';

class CircuitsScreenModel extends ElementaryModel {
  Future<CircuitsModel> loadCircuits() async {
    final rawData = await CircuitsLoader.loadData();

    return CircuitsModel.fromJson(rawData.mrData as Map<String, dynamic>);
  }
}
