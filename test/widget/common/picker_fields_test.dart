import 'package:f1_pet_project/common/widgets/text_fields/constructor_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/driver_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('DriverPickerField', () {
    testWidgets('opens sheet and updates selection', (tester) async {
      DriverModel? selected = ControllerFixtures.driver;

      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) => DriverPickerField(
            driver: selected,
            loadDrivers: () async => [ControllerFixtures.driver],
            onChanged: (driver) => setState(() => selected = driver),
          ),
        ),
      );

      expect(find.textContaining('Verstappen'), findsOneWidget);
      await tester.tap(find.byType(DriverPickerField));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Verstappen').last);
      await tester.pumpAndSettle();
      expect(selected?.driverId, 'max_verstappen');
    });
  });

  group('ConstructorPickerField', () {
    testWidgets('opens sheet and updates selection', (tester) async {
      ConstructorModel? selected;

      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) => ConstructorPickerField(
            constructor: selected,
            loadConstructors: () async => [ControllerFixtures.constructor],
            onChanged: (c) => setState(() => selected = c),
          ),
        ),
      );

      await tester.tap(find.byType(ConstructorPickerField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Red Bull'));
      await tester.pumpAndSettle();
      expect(selected?.constructorId, 'red_bull');
    });
  });

  group('RacePickerField', () {
    testWidgets('disabled without season', (tester) async {
      final display = TextEditingController();
      addTearDown(display.dispose);

      await tester.pumpApp(
        RacePickerField(
          displayController: display,
          seasonYear: '',
          onPicked: (_) {},
        ),
      );

      expect(find.byType(RacePickerField), findsOneWidget);
    });
  });
}
