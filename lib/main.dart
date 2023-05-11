import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/utils/objectbox/objectbox.dart';
import 'package:flutter/material.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;
void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  runApp(App());
}
