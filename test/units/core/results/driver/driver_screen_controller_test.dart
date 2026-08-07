import 'dart:async';

import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/driver/controllers/driver_screen_controller/driver_screen_controller.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_espn_media_repository.dart';
import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/riverpod_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const career = CareerStats<ConstructorModel>(
    races: 100,
    wins: 20,
    podiums: 40,
    poles: 15,
    current: [],
    related: [],
  );

  final args = DriverScreenArgs(driver: ControllerFixtures.driver);

  (DriverScreenController, ProviderContainer) createController({
    FakeEspnMediaRepository? espn,
    Future<CareerStats<ConstructorModel>> Function({
      required String driverId,
      List<ConstructorModel> current,
    })?
    fetchCareerStatsForTest,
    bool useCareerRepository = false,
  }) {
    late DriverScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        if (espn != null) espnMediaRepositoryProvider.overrideWithValue(espn),
        if (useCareerRepository)
          driverCareerRepositoryProvider.overrideWithValue(FakeDriverCareerRepository()),
        driverScreenControllerProvider(args).overrideWith(
          () => controller = DriverScreenController(
            args,
            fetchCareerStatsForTest: fetchCareerStatsForTest,
          ),
        ),
      ],
    )
    ..listen(driverScreenControllerProvider(args), (_, _) {});
    controller = container.read(driverScreenControllerProvider(args).notifier);
    return (controller, container);
  }

  DriverState stateOf(ProviderContainer container) => container.read(driverScreenControllerProvider(args));

  group('DriverScreenController', () {
    test('loadAll sets career and espn card', () async {
      final espn = FakeEspnMediaRepository(
        driverCard: const EspnDriverCardData(
          photoUrl: 'https://example.com/photo.png',
          news: [NewsArticleModel(id: 1, headline: 'News', description: 'd', webUrl: 'https://x.com')],
        ),
      );
      final (controller, container) = createController(espn: espn, useCareerRepository: true);

      await controller.loadAll();

      final state = stateOf(container);
      expect(state.isLoaded, isTrue);
      expect(state.careerStats.value?.wins, 20);
      expect(state.espnCardData.photoUrl, 'https://example.com/photo.png');
      expect(state.espnCardData.news, hasLength(1));
      expect(espn.driverCardCalls, 1);
    });

    test('espn failure yields empty card without failing career', () async {
      final (controller, container) = createController(
        espn: FakeEspnMediaRepository(throwOnDriverCard: true),
        useCareerRepository: true,
      );

      await controller.loadAll();

      final state = stateOf(container);
      expect(state.isLoaded, isTrue);
      expect(state.screenError, isNull);
      expect(state.espnCardData.photoUrl, isNull);
      expect(state.espnCardData.news, isEmpty);
    });

    test('career failure sets screenError', () async {
      final (controller, container) = createController(
        espn: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async {
          throw ResponseParseException('career failed');
        },
      );

      await controller.loadCareerStats();

      final state = stateOf(container);
      expect(state.careerStats.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('refreshAll reloads career', () async {
      var calls = 0;
      final (controller, container) = createController(
        espn: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async {
          calls++;
          return career;
        },
      );

      await controller.refreshAll();
      expect(calls, 1);
      expect(stateOf(container).isLoaded, isTrue);
    });

    test('isEspnLoading while card fetch is pending', () async {
      final gate = Completer<EspnDriverCardData>();
      final espn = FakeEspnMediaRepository(driverCardFuture: gate.future);
      final (controller, container) = createController(espn: espn, useCareerRepository: true);

      final pending = controller.loadEspnCard();
      expect(stateOf(container).isEspnLoading, isTrue);
      gate.complete(const EspnDriverCardData(photoUrl: 'https://x.com/p.png'));
      await pending;
      expect(stateOf(container).isEspnLoading, isFalse);
    });
  });
}
