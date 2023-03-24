import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:flutter/material.dart';

abstract class IRaceSearchScreenWM extends IWidgetModel {
  /// скролл страницы
  ScrollController get scrollController;

  /// год
  TextEditingController get yearController;

  /// раунд
  TextEditingController get roundController;

  /// результаты гонки
  ListenableState<EntityState<RacesModel?>> get searchedRace;

  /// гонок не найдено
  ListenableState<String> get errorMessage;

  /// загружены ли данные
  ListenableState<bool> get dataIsLoaded;

  /// загружены ли данные
  ListenableState<bool> get fieldsInputted;

  /// время лучшего круга
  String get fastestLap;

  /// закрытие страницы
  void onPop();

  /// загрузка результатов для конкретной гонки
  void loadRaceResults();

  /// загрузка результатов для конкретной гонки
  void checkFields();
}

class RaceSearchScreenWM
    extends WidgetModel<RaceSearchScreen, RaceSearchScreenModel>
    implements IRaceSearchScreenWM {
  final _scrollController = ScrollController();

  final _yearController = TextEditingController();

  final _roundController = TextEditingController();

  final _searchedRace = EntityStateNotifier<RacesModel?>();

  final _dataIsLoaded = StateNotifier<bool>(initValue: true);

  final _fieldsInputted = StateNotifier<bool>(initValue: false);

  final _errorMessage = StateNotifier<String>(initValue: '');

  @override
  ListenableState<EntityState<RacesModel?>> get searchedRace => _searchedRace;

  @override
  ListenableState<bool> get dataIsLoaded => _dataIsLoaded;

  @override
  ListenableState<bool> get fieldsInputted => _fieldsInputted;

  @override
  ListenableState<String> get errorMessage => _errorMessage;

  @override
  TextEditingController get yearController => _yearController;

  @override
  TextEditingController get roundController => _roundController;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  String get fastestLap => _fastestLap;

  String _fastestLap = '999999';

  RaceSearchScreenWM(super.model);

  @override
  void onPop() {
    context.router.removeLast();
  }

  @override
  void checkFields() => _fieldsInputted.accept(
        _yearController.text.length == 4 && _roundController.text.isNotEmpty,
      );

  @override
  Future<void> loadRaceResults() async {
    _dataIsLoaded.accept(false);
    FocusManager.instance.primaryFocus?.unfocus();
    await execute<ScheduleModel>(
      () => model.loadRaceResults(
        year: _yearController.text,
        round: _roundController.text,
      ),
      before: _searchedRace.loading,
      onSuccess: (data) {
        if (data!.RaceTable.Races.isNotEmpty) {
          _searchedRace.content(data.RaceTable.Races[0]);
          Future<void>.delayed(
            const Duration(milliseconds: 100),
            _animateToTable,
          );
        } else {
          _searchedRace.content(null);
          _errorMessage.accept(
            'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.',
          );
        }
      },
      onError: (error) {
        _searchedRace.error(error);
        _errorMessage.accept(error.title);
      },
    );
    if (_searchedRace.value!.data != null) {
      for (final element in _searchedRace.value!.data!.Results!) {
        if (element.FastestLap != null && _fastestLap.compareTo(element.FastestLap!.Time.time) == 1) {
          _fastestLap = element.FastestLap!.Time.time;
        }
      }
    }

    _dataIsLoaded.accept(true);
  }

  /// Скролл к расписанию
  void _animateToTable() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeOutCubic,
    );
  }
}

RaceSearchScreenWM createRaceSearchScreenWM(BuildContext _) =>
    RaceSearchScreenWM(RaceSearchScreenModel());
