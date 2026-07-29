import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_bridge.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_keys.dart';

/// Готовит данные next GP / standings top-3 и пушит их в home widgets (Android/iOS).
class AppWidgetSyncService {
  AppWidgetSyncService({
    required ScheduleRepository scheduleRepository,
    required CurrentStandingsRepository standingsRepository,
  }) : _scheduleRepository = scheduleRepository,
       _standingsRepository = standingsRepository;

  final ScheduleRepository _scheduleRepository;
  final CurrentStandingsRepository _standingsRepository;

  var _syncing = false;

  /// Обновляет оба виджета (schedule + drivers standings).
  Future<void> sync() async {
    if (!PlatformCapabilities.hasHomeWidgets || _syncing) {
      return;
    }
    _syncing = true;
    try {
      final nextGp = await _nextGpPayload();
      final standings = await _standingsPayload();
      await AppWidgetBridge.saveAndUpdate(
        data: {...nextGp, ...standings},
        providers: [
          AppWidgetKeys.nextGpProvider,
          AppWidgetKeys.standingsProvider,
        ],
      );
    } on Object catch (error, stackTrace) {
      logger.e('AppWidget sync failed', error: error, stackTrace: stackTrace);
    } finally {
      _syncing = false;
    }
  }

  Future<Map<String, Object?>> _nextGpPayload() async {
    final races = (await _scheduleRepository.getSchedule()).schedule.raceTable.races;
    final now = DateTime.now();
    final upcoming = races.where((race) => RaceDateTimeHelper.isUpcoming(race, now)).toList()
      ..sort((a, b) => RaceDateTimeHelper.raceLocal(a).compareTo(RaceDateTimeHelper.raceLocal(b)));

    if (upcoming.isEmpty) {
      return {AppWidgetKeys.nextGpHasData: false};
    }

    final race = upcoming.first;
    final target = RaceDateTimeHelper.countdownTarget(race);
    return {
      AppWidgetKeys.nextGpHasData: true,
      AppWidgetKeys.nextGpRaceName: _shortRaceName(race),
      AppWidgetKeys.nextGpCircuit: race.circuit.circuitName,
      AppWidgetKeys.nextGpTargetMs: target.millisecondsSinceEpoch.toString(),
    };
  }

  Future<Map<String, Object?>> _standingsPayload() async {
    final model = await _standingsRepository.drivers();
    final list = model.standingsTable.standingsLists.first;
    final top = (list.driverStandings ?? []).take(3).toList();

    if (top.isEmpty) {
      return {AppWidgetKeys.standingsHasData: false};
    }

    final data = <String, Object?>{
      AppWidgetKeys.standingsHasData: true,
      AppWidgetKeys.standingsSeason: list.season,
      AppWidgetKeys.standingsRound: list.round,
    };

    for (var i = 0; i < 3; i++) {
      final entry = i < top.length ? top[i] : null;
      data[AppWidgetKeys.driverCode(i + 1)] = _driverLabel(entry);
      data[AppWidgetKeys.driverPoints(i + 1)] = entry?.points ?? '';
    }
    return data;
  }

  static String _shortRaceName(RacesModel race) {
    final name = race.raceName.trim();
    const suffix = ' Grand Prix';
    if (name.endsWith(suffix) && name.length > suffix.length) {
      return name.substring(0, name.length - suffix.length);
    }
    return name;
  }

  static String _driverLabel(DriverStandingsModel? entry) {
    if (entry == null) {
      return '';
    }
    final code = entry.driver.code;
    if (code != null && code.isNotEmpty && code != 'none') {
      return code;
    }
    return entry.driver.familyName.toUpperCase();
  }
}
