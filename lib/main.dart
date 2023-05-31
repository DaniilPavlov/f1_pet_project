import 'package:f1_pet_project/app.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

// TODO(pavlov): add pushes
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AndroidYandexMap.useAndroidViewSurface = false;

  runApp(App());
}
