import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDataRefresh', () {
    test('clearAll invalidates caches without wiping them', () async {
      final requestHandler = _TrackingRequestHandler();
      final schedule = _TrackingScheduleRepository();
      final seasons = _TrackingSeasonsRepository();
      final news = _TrackingNewsRepository();
      final scoreboard = _TrackingScoreboardRepository();

      await AppDataRefresh(
        requestHandler: requestHandler,
        scheduleRepository: schedule,
        seasonsRepository: seasons,
        newsRepository: news,
        scoreboardRepository: scoreboard,
      ).clearAll();

      expect(requestHandler.invalidated, isTrue);
      expect(schedule.invalidated, isTrue);
      expect(seasons.invalidated, isTrue);
      expect(news.invalidated, isTrue);
      expect(scoreboard.invalidated, isTrue);
    });
  });
}

class _TrackingRequestHandler extends RequestHandler {
  bool invalidated = false;

  @override
  void invalidateCache() => invalidated = true;
}

class _TrackingScheduleRepository extends ScheduleRepository {
  bool invalidated = false;

  @override
  void invalidate() => invalidated = true;
}

class _TrackingSeasonsRepository extends SeasonsRepository {
  bool invalidated = false;

  @override
  void invalidate() => invalidated = true;
}

class _TrackingNewsRepository extends NewsRepository {
  _TrackingNewsRepository() : super(dio: Dio());

  bool invalidated = false;

  @override
  void invalidate() => invalidated = true;
}

class _TrackingScoreboardRepository extends EspnScoreboardRepository {
  _TrackingScoreboardRepository() : super(dio: Dio());

  bool invalidated = false;

  @override
  void invalidate() => invalidated = true;
}
