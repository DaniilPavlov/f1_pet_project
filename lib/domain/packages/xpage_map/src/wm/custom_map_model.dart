import 'package:elementary/elementary.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomMapModel extends ElementaryModel {
  final streamedMapObjects = StateNotifier<List<MapObject>>();
}
