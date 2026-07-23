import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/request_handler.dart';

/// Pull-to-refresh: помечает кэши устаревшими, не удаляя данные (офлайн-fallback).
///
/// GoF Structural Facade — один [clearAll] координирует инвалидацию Jolpica / schedule /
/// seasons / news / scoreboard; UI не знает внутренностей кэшей.
class AppDataRefresh {
  AppDataRefresh({
    required RequestHandler requestHandler,
    required ScheduleRepository scheduleRepository,
    required SeasonsRepository seasonsRepository,
    required NewsRepository newsRepository,
    required EspnScoreboardRepository scoreboardRepository,
  }) : _requestHandler = requestHandler,
       _scheduleRepository = scheduleRepository,
       _seasonsRepository = seasonsRepository,
       _newsRepository = newsRepository,
       _scoreboardRepository = scoreboardRepository;

  final RequestHandler _requestHandler;
  final ScheduleRepository _scheduleRepository;
  final SeasonsRepository _seasonsRepository;
  final NewsRepository _newsRepository;
  final EspnScoreboardRepository _scoreboardRepository;

  Future<void> clearAll() async {
    _requestHandler.invalidateCache();
    _scheduleRepository.invalidate();
    _seasonsRepository.invalidate();
    _newsRepository.invalidate();
    _scoreboardRepository.invalidate();
  }
}
