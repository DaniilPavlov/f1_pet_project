import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/utils/objectbox/isar_value_model.dart';
import 'package:f1_pet_project/utils/objectbox/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [IsarValueModelSchema],
    directory: dir.path,
  );
  final newIsarValue = IsarValueModel()..value = 4;

  await isar.writeTxn(() async {
    await isar.isarValueModels.put(newIsarValue); // insert & update
  });

  final existingValue = await isar.isarValueModels.get(newIsarValue.id); // get
  debugPrint(existingValue!.value.toString());
  await isar.writeTxn(() async {
    await isar.isarValueModels.delete(existingValue.id); // delete
  });
  debugPrint(isar.isarValueModels.count().toString());
  objectbox = await ObjectBox.create();
  runApp(ProviderScope(child: App()));
}
