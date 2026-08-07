import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_context_menu_builder.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_map_bottom_sheet.dart';
import 'package:f1_pet_project/core/results/components/weekend_session_results_sheet.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_button_section.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/l10n/app_localizations_ru.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/riverpod_container.dart';

void main() {
  group('ErrorCopy', () {
    test('sync updates static strings from l10n', () {
      ErrorCopy.sync(AppLocalizationsRu());
      expect(ErrorCopy.noConnection, AppLocalizationsRu().noConnection);
      expect(ErrorCopy.tooManyRequests, AppLocalizationsRu().tooManyRequests);

      ErrorCopy.sync(AppLocalizationsEn());
      expect(ErrorCopy.noConnection, AppLocalizationsEn().noConnection);
      expect(ErrorCopy.errorRetrySubtitle, AppLocalizationsEn().errorRetrySubtitle);
      expect(ErrorCopy.requestError, AppLocalizationsEn().requestError);
      expect(ErrorCopy.responseParseError, AppLocalizationsEn().responseParseError);
      expect(ErrorCopy.unexpectedError, AppLocalizationsEn().unexpectedError);
      expect(ErrorCopy.noConnectionSubtitle, AppLocalizationsEn().noConnectionSubtitle);
      expect(ErrorCopy.tooManyRequestsSubtitle, AppLocalizationsEn().tooManyRequestsSubtitle);
    });
  });

  group('SearchButtonSection', () {
    testWidgets('shows disabled search until fields valid', (tester) async {
      await tester.pumpApp(
        ProviderScope(
          overrides: [
            raceSearchScreenControllerProvider('en').overrideWith(() => RaceSearchScreenController('en')),
          ],
          child: const SearchButtonSection(languageCode: 'en'),
        ),
      );

      expect(find.text(AppLocalizationsEn().search), findsOneWidget);
      expect(find.byType(SearchButtonSection), findsOneWidget);
    });

    testWidgets('shows loading indicator when dataIsLoaded is false', (tester) async {
      final completer = Completer<ScheduleModel>();
      final container = createNotifierContainer(
        overrides: [
          raceSearchScreenControllerProvider('en').overrideWith(
            () => RaceSearchScreenController(
              'en',
              fetchRaceResultsForTest: ({required year, required round}) => completer.future,
              analyticsForTest: const NoOpAnalyticsGateway(),
            ),
          ),
        ],
      );

      await tester.pumpApp(
        UncontrolledProviderScope(
          container: container,
          child: const SearchButtonSection(languageCode: 'en'),
        ),
      );

      final controller = container.read(raceSearchScreenControllerProvider('en').notifier);
      controller.yearController.text = '2024';
      controller.roundController.text = '5';
      controller.checkFields();
      unawaited(controller.loadRaceResults());
      await tester.pump();

      expect(find.byType(CustomLoadingIndicator), findsOneWidget);

      completer.complete(ControllerFixtures.scheduleModel);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
    });
  });

  group('CircuitsMapBottomSheet', () {
    testWidgets('shows circuit name and details CTA', (tester) async {
      await tester.pumpApp(SizedBox(height: 420, child: CircuitsMapBottomSheet(circuit: ControllerFixtures.circuit)));

      expect(find.text('Monaco'), findsOneWidget);
      expect(find.text(AppLocalizationsEn().circuitDetails), findsOneWidget);
    });
  });

  group('WeekendSessionResultsSheet.show', () {
    testWidgets('opens modal with session title', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => WeekendSessionResultsSheet.show(
              context,
              const EspnScoreboardSession(abbreviation: 'FP1', statusState: 'post', statusDetail: 'Final'),
            ),
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizationsEn().weekendSessionResultsTitle('FP1')), findsOneWidget);
    });
  });

  group('CustomAppBar logo', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('shows logo when title is null', (tester) async {
      await tester.pumpApp(
        const Scaffold(appBar: CustomAppBar(showPreferences: false), body: SizedBox.shrink()),
        wrapInScaffold: false,
        wrapApp: (app) => ProviderScope(child: app),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('CustomContextMenuBuilder', () {
    testWidgets('appears on long-press of CustomTextField', (tester) async {
      final controller = TextEditingController(text: 'hello');
      addTearDown(controller.dispose);

      await tester.pumpApp(CustomTextField(controller: controller, label: 'Name'));

      await tester.longPress(find.byType(TextFormField));
      await tester.pumpAndSettle();

      expect(find.byType(CustomContextMenuBuilder), findsOneWidget);
    });
  });
}
