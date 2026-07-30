import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_context_menu_builder.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_map_bottom_sheet.dart';
import 'package:f1_pet_project/core/results/components/weekend_session_results_sheet.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_button_section.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/l10n/app_localizations_ru.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

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
      final controller = RaceSearchScreenController(l10n: AppLocalizationsEn());
      addTearDown(controller.dispose);

      await tester.pumpApp(Provider.value(value: controller, child: const SearchButtonSection()));

      expect(find.text(AppLocalizationsEn().search), findsOneWidget);
      expect(find.byType(SearchButtonSection), findsOneWidget);
    });

    testWidgets('shows loading indicator when dataIsLoaded is false', (tester) async {
      final controller = RaceSearchScreenController(l10n: AppLocalizationsEn());
      addTearDown(controller.dispose);
      controller.dataIsLoaded = false;

      await tester.pumpApp(Provider.value(value: controller, child: const SearchButtonSection()));

      expect(find.byType(CustomLoadingIndicator), findsOneWidget);
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
      final locale = LocaleController();
      final theme = ThemeController();

      await tester.pumpApp(
        MultiProvider(
          providers: [
            Provider<LocaleController>.value(value: locale),
            Provider<ThemeController>.value(value: theme),
          ],
          child: const Scaffold(appBar: CustomAppBar(showPreferences: false), body: SizedBox.shrink()),
        ),
        wrapInScaffold: false,
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
