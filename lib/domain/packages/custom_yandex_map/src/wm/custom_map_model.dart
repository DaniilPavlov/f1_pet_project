import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomMapModel extends ElementaryModel {
  final streamedMapObjects = StateNotifier<List<MapObject>>();
}
