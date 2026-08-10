import 'dart:async';

import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/driver/managers/driver_page_manager.dart';
import 'package:f1_pet_project/core/results/driver/providers.dart';
import 'package:f1_pet_project/core/results/driver/state/state_models/driver_page_args.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_espn_media_repository.dart';
import '../../../../helpers/fake_repositories.dart';

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

  final args = DriverPageArgs(driver: ControllerFixtures.driver);

  ProviderContainer buildContainer({
    FakeEspnMediaRepository? espn,
    Future<CareerStats<ConstructorModel>> Function({
      required String driverId,
      List<ConstructorModel> current,
    })?
    fetchCareerStatsForTest,
    bool useCareerRepository = false,
  }) {
    return ProviderContainer(
      overrides: [
        if (espn != null) espnMediaRepositoryProvider.overrideWithValue(espn),
        if (useCareerRepository)
          driverCareerRepositoryProvider.overrideWithValue(FakeDriverCareerRepository()),
        driverPageManagerProvider(args).overrideWith((ref) {
          return DriverPageManager(
            args: args,
            holder: ref.watch(driverPageStateHolderProvider(args).notifier),
            careerRepository: useCareerRepository ? ref.watch(driverCareerRepositoryProvider) : null,
            espnMediaRepository: espn,
            fetchCareerStatsForTest: fetchCareerStatsForTest,
          );
        }),
      ],
    );
  }

  group('DriverPageManager', () {
    test('loadAll sets career and espn card', () async {
      final espn = FakeEspnMediaRepository(
        driverCard: const EspnDriverCardData(
          photoUrl: 'https://example.com/photo.png',
          news: [NewsArticleModel(id: 1, headline: 'News', description: 'd', webUrl: 'https://x.com')],
        ),
      );
      final container = buildContainer(espn: espn, useCareerRepository: true);
      addTearDown(container.dispose);

      await container.read(driverPageManagerProvider(args)).loadAll();

      final state = container.read(driverPageStateHolderProvider(args));
      expect(state.isLoaded, isTrue);
      expect(state.careerStats.value?.wins, 20);
      expect(state.espnCardData.photoUrl, 'https://example.com/photo.png');
      expect(state.espnCardData.news, hasLength(1));
      expect(espn.driverCardCalls, 1);
    });

    test('espn failure yields empty card without failing career', () async {
      final container = buildContainer(
        espn: FakeEspnMediaRepository(throwOnDriverCard: true),
        useCareerRepository: true,
      );
      addTearDown(container.dispose);

      await container.read(driverPageManagerProvider(args)).loadAll();

      final state = container.read(driverPageStateHolderProvider(args));
      expect(state.isLoaded, isTrue);
      expect(state.screenError, isNull);
      expect(state.espnCardData.photoUrl, isNull);
      expect(state.espnCardData.news, isEmpty);
    });

    test('career failure sets screenError', () async {
      final container = buildContainer(
        espn: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async {
          throw ResponseParseException('career failed');
        },
      );
      addTearDown(container.dispose);

      await container.read(driverPageManagerProvider(args)).loadCareerStats();

      final state = container.read(driverPageStateHolderProvider(args));
      expect(state.careerStats.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('refreshAll reloads career', () async {
      var calls = 0;
      final container = buildContainer(
        espn: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async {
          calls++;
          return career;
        },
      );
      addTearDown(container.dispose);

      await container.read(driverPageManagerProvider(args)).refreshAll();
      expect(calls, 1);
      expect(container.read(driverPageStateHolderProvider(args)).isLoaded, isTrue);
    });

    test('isEspnLoading while card fetch is pending', () async {
      final gate = Completer<EspnDriverCardData>();
      final espn = FakeEspnMediaRepository(driverCardFuture: gate.future);
      final container = buildContainer(espn: espn, useCareerRepository: true);
      addTearDown(container.dispose);

      final pending = container.read(driverPageManagerProvider(args)).loadEspnCard();
      expect(container.read(driverPageStateHolderProvider(args)).isEspnLoading, isTrue);
      gate.complete(const EspnDriverCardData(photoUrl: 'https://x.com/p.png'));
      await pending;
      expect(container.read(driverPageStateHolderProvider(args)).isEspnLoading, isFalse);
    });
  });
}
