import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:flutter/foundation.dart';

/// Автоскоринг незакрытых уикендов по фактическим quali/race результатам.
class PredictorScoringCoordinator {
  PredictorScoringCoordinator({
    RaceWeekendRepository? raceWeekendRepository,
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifying,
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResults,
  }) : _raceWeekendRepository = raceWeekendRepository ?? const RaceWeekendRepository(),
       _fetchQualifying = fetchQualifying,
       _fetchRaceResults = fetchRaceResults;

  final RaceWeekendRepository _raceWeekendRepository;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifying;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResults;

  /// Возвращает обновлённый store или `null`, если скорить нечего / ничего не изменилось.
  Future<PredictorStore?> scoreAllPending({
    required PredictorStore store,
    required String year,
    required DateTime now,
  }) async {
    final season = store.season(year);
    if (season == null || season.weekends.isEmpty) {
      return null;
    }

    var nextStore = store;
    var changed = false;
    for (final weekend in season.weekends.values) {
      final scored = await scoreWeekend(year: year, weekend: weekend, now: now);
      if (scored != null && weekendScoreChanged(weekend, scored)) {
        nextStore = nextStore.upsertWeekend(year: year, weekend: scored);
        changed = true;
      }
    }
    return changed ? nextStore : null;
  }

  Future<PredictorWeekendPrediction?> scoreWeekend({
    required String year,
    required PredictorWeekendPrediction weekend,
    required DateTime now,
  }) async {
    if (weekend.qualifyingOrder.isEmpty && weekend.raceOrder.isEmpty) {
      return null;
    }

    var qualiActual = _nonEmpty(weekend.actualQualifyingOrder);
    var raceActual = _nonEmpty(weekend.actualRaceOrder);

    if (qualiActual == null) {
      try {
        final qualiModel = await _fetchQualifyingResults(year: year, round: weekend.round);
        final list = qualiModel.raceTable.races.isEmpty
            ? null
            : qualiModel.raceTable.races.first.qualifyingResults;
        if (list != null && list.isNotEmpty) {
          qualiActual = PredictorScoreService.qualifyingActualOrder(list);
        }
      } on Object {
        qualiActual = null;
      }
    }

    if (raceActual == null) {
      try {
        final raceModel = await _fetchRace(year: year, round: weekend.round);
        final list = raceModel.raceTable.races.isEmpty ? null : raceModel.raceTable.races.first.results;
        if (list != null && list.isNotEmpty) {
          raceActual = PredictorScoreService.raceActualOrder(list);
        }
      } on Object {
        raceActual = null;
      }
    }

    if (qualiActual == null && raceActual == null) {
      return null;
    }

    return PredictorScoreService.applyResults(
      weekend: weekend,
      actualQualifyingOrder: qualiActual,
      actualRaceOrder: raceActual,
      now: now,
    );
  }

  static bool weekendScoreChanged(PredictorWeekendPrediction before, PredictorWeekendPrediction after) {
    return before.qualiPoints != after.qualiPoints ||
        before.racePoints != after.racePoints ||
        !listEquals(before.actualQualifyingOrder, after.actualQualifyingOrder) ||
        !listEquals(before.actualRaceOrder, after.actualRaceOrder);
  }

  static List<String>? _nonEmpty(List<String>? list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    return list;
  }

  Future<ScheduleModel> _fetchQualifyingResults({required String year, required String round}) {
    final forTest = _fetchQualifying;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.qualifyingResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchRace({required String year, required String round}) {
    final forTest = _fetchRaceResults;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.raceResults(year: year, round: round);
  }
}
