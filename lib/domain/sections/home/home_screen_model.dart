// ignore_for_file: avoid_annotating_with_dynamic

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/home/circuits/circuits_loader.dart';

class HomeScreenModel extends ElementaryModel {
  Future<CircuitsModel> loadCircuits() async {
    final rawData = await CircuitsLoader.loadData();

    return CircuitsModel.fromJson(rawData.MRData as Map<String, dynamic>);
  }
}
