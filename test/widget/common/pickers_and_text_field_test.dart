import 'package:f1_pet_project/common/widgets/text_fields/constructor_picker_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/driver_picker_bottom_sheet.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('CustomTextField', () {
    testWidgets('shows label, hint and accepts input', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var changed = '';

      await tester.pumpApp(
        CustomTextField(
          controller: controller,
          label: 'Year',
          hintText: '2024',
          onChanged: (v) => changed = v,
        ),
      );

      expect(find.text('Year'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), '2025');
      expect(changed, '2025');
      expect(controller.text, '2025');
    });

    testWidgets('shows error text', (tester) async {
      await tester.pumpApp(
        const CustomTextField(label: 'Year', errorText: 'Invalid'),
      );

      expect(find.text('Invalid'), findsOneWidget);
    });
  });

  group('DriverPickerBottomSheet', () {
    testWidgets('lists drivers and returns selection', (tester) async {
      DriverModel? selected;

      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              selected = await showModalBottomSheet<DriverModel>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DriverPickerBottomSheet(
                  loadDrivers: () async => [ControllerFixtures.driver],
                  selectedDriverId: ControllerFixtures.driver.driverId,
                  enableSearch: true,
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Verstappen'), findsOneWidget);
      await tester.tap(find.textContaining('Verstappen'));
      await tester.pumpAndSettle();
      expect(selected?.driverId, 'max_verstappen');
    });
  });

  group('ConstructorPickerBottomSheet', () {
    testWidgets('lists constructors', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ConstructorPickerBottomSheet(
                loadConstructors: () async => [ControllerFixtures.constructor],
              ),
            ),
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Red Bull'), findsOneWidget);
    });
  });
}
