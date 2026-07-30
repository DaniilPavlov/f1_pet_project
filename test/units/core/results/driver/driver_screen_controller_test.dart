import 'dart:async';

import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/driver/controllers/driver_screen_controller/driver_screen_controller.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_espn_media_repository.dart';

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

  group('DriverScreenController', () {
    test('loadAll sets career and espn card', () async {
      final espn = FakeEspnMediaRepository(
        driverCard: const EspnDriverCardData(
          photoUrl: 'https://example.com/photo.png',
          news: [NewsArticleModel(id: 1, headline: 'News', description: 'd', webUrl: 'https://x.com')],
        ),
      );
      final controller = DriverScreenController(
        driver: ControllerFixtures.driver,
        espnMediaRepository: espn,
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async => career,
      );

      await controller.loadAll();

      expect(controller.isLoaded, isTrue);
      expect(controller.careerStats.value?.wins, 20);
      expect(controller.espnCardData.photoUrl, 'https://example.com/photo.png');
      expect(controller.espnCardData.news, hasLength(1));
      expect(espn.driverCardCalls, 1);
    });

    test('espn failure yields empty card without failing career', () async {
      final controller = DriverScreenController(
        driver: ControllerFixtures.driver,
        espnMediaRepository: FakeEspnMediaRepository(throwOnDriverCard: true),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async => career,
      );

      await controller.loadAll();

      expect(controller.isLoaded, isTrue);
      expect(controller.screenError, isNull);
      expect(controller.espnCardData.photoUrl, isNull);
      expect(controller.espnCardData.news, isEmpty);
    });

    test('career failure sets screenError', () async {
      final controller = DriverScreenController(
        driver: ControllerFixtures.driver,
        espnMediaRepository: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async {
          throw ResponseParseException('career failed');
        },
      );

      await controller.loadCareerStats();

      expect(controller.careerStats.isError, isTrue);
      expect(controller.screenError, isNotNull);
    });

    test('refreshAll reloads career', () async {
      var calls = 0;
      final controller = DriverScreenController(
        driver: ControllerFixtures.driver,
        espnMediaRepository: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async {
          calls++;
          return career;
        },
      );

      await controller.refreshAll();
      expect(calls, 1);
      expect(controller.isLoaded, isTrue);
    });

    test('isEspnLoading while card fetch is pending', () async {
      final gate = Completer<EspnDriverCardData>();
      final espn = FakeEspnMediaRepository(driverCardFuture: gate.future);
      final controller = DriverScreenController(
        driver: ControllerFixtures.driver,
        espnMediaRepository: espn,
        fetchCareerStatsForTest: ({required driverId, List<ConstructorModel> current = const []}) async => career,
      );

      final pending = controller.loadEspnCard();
      expect(controller.isEspnLoading, isTrue);
      gate.complete(const EspnDriverCardData(photoUrl: 'https://x.com/p.png'));
      await pending;
      expect(controller.isEspnLoading, isFalse);
    });
  });
}
